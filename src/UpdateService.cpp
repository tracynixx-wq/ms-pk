#include "UpdateService.h"

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkRequest>
#include <QProcess>
#include <QStandardPaths>
#include <QVersionNumber>

#ifdef Q_OS_WIN
#include <windows.h>
#endif

UpdateService::UpdateService(QObject *parent) : QObject(parent) {}

void UpdateService::setStatus(const QString &status)
{
    if (m_status == status) return;
    m_status = status;
    emit statusChanged();
}

void UpdateService::checkForUpdates()
{
    setStatus(QStringLiteral("Проверяем обновления…"));
    QNetworkRequest request(QUrl(QStringLiteral("https://api.github.com/repos/tracynixx-wq/ms-pk/releases/latest")));
    request.setHeader(QNetworkRequest::UserAgentHeader, QStringLiteral("Message-Desktop-Updater"));
    request.setRawHeader("Accept", "application/vnd.github+json");
    auto *reply = m_network.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply] {
        const auto data = reply->readAll();
        const auto error = reply->error();
        reply->deleteLater();
        if (error != QNetworkReply::NoError) {
            setStatus(QStringLiteral("Не удалось проверить обновления. Попробуйте позже."));
            return;
        }
        const auto doc = QJsonDocument::fromJson(data);
        if (!doc.isObject()) {
            setStatus(QStringLiteral("Сервер обновлений вернул неверный ответ."));
            return;
        }
        const auto release = doc.object();
        const QString tag = release.value(QStringLiteral("tag_name")).toString();
        const QString remoteVersion = tag.startsWith('v') ? tag.mid(1) : tag;
        const auto assets = release.value(QStringLiteral("assets")).toArray();
        QUrl asset;
        for (const auto &value : assets) {
            const auto item = value.toObject();
            if (item.value(QStringLiteral("name")).toString() == QStringLiteral("Message-Desktop-Windows-x64.zip")) {
                asset = QUrl(item.value(QStringLiteral("browser_download_url")).toString());
                break;
            }
        }
        if (remoteVersion.isEmpty() || !asset.isValid()) {
            setStatus(QStringLiteral("Публичная сборка обновления пока недоступна."));
            return;
        }
        const auto local = QVersionNumber::fromString(QCoreApplication::applicationVersion());
        const auto remote = QVersionNumber::fromString(remoteVersion);
        m_latestVersion = remoteVersion;
        m_assetUrl = asset;
        m_updateAvailable = QVersionNumber::compare(remote, local) > 0;
        emit updateAvailableChanged();
        setStatus(m_updateAvailable
            ? QStringLiteral("Доступна версия %1").arg(remoteVersion)
            : QStringLiteral("Установлена последняя версия."));
    });
}

void UpdateService::downloadAndInstall()
{
#ifdef Q_OS_WIN
    if (!m_assetUrl.isValid()) {
        setStatus(QStringLiteral("Сначала проверьте наличие обновлений."));
        return;
    }
    setStatus(QStringLiteral("Загружаем обновление…"));
    QNetworkRequest request(m_assetUrl);
    request.setHeader(QNetworkRequest::UserAgentHeader, QStringLiteral("Message-Desktop-Updater"));
    auto *reply = m_network.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply] {
        const QByteArray bytes = reply->readAll();
        const auto error = reply->error();
        reply->deleteLater();
        if (error != QNetworkReply::NoError || bytes.isEmpty()) {
            setStatus(QStringLiteral("Не удалось загрузить обновление."));
            return;
        }
        const QString temp = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
        const QString zipPath = QDir(temp).filePath(QStringLiteral("Message-Desktop-update.zip"));
        QFile zip(zipPath);
        if (!zip.open(QIODevice::WriteOnly) || zip.write(bytes) != bytes.size()) {
            setStatus(QStringLiteral("Не удалось сохранить архив обновления."));
            return;
        }
        zip.close();

        const QString appDir = QCoreApplication::applicationDirPath();
        const QString exePath = QDir(appDir).filePath(QFileInfo(QCoreApplication::applicationFilePath()).fileName());
        const QString scriptPath = QDir(temp).filePath(QStringLiteral("message-desktop-update.ps1"));
        const QString zipPathEscaped = QString(zipPath).replace("'", "''");
        const QString appDirEscaped = QString(appDir).replace("'", "''");
        const QString exePathEscaped = QString(exePath).replace("'", "''");
        QString script = QStringLiteral(
            "$ErrorActionPreference='Stop'\n"
            "$pidToWait=%1\n"
            "$zip='%2'\n"
            "$app='%3'\n"
            "$exe='%4'\n"
            "try { Wait-Process -Id $pidToWait -ErrorAction SilentlyContinue; Start-Sleep -Milliseconds 700; "
            "$parent=Split-Path -Parent $app; $stage=Join-Path $parent 'Message-update-stage'; "
            "$backup=Join-Path $parent 'Message-update-old'; "
            "Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction SilentlyContinue; "
            "Expand-Archive -LiteralPath $zip -DestinationPath $stage -Force; "
            "if (Test-Path $backup) { Remove-Item -LiteralPath $backup -Recurse -Force }; "
            "Move-Item -LiteralPath $app -Destination $backup; "
            "Move-Item -LiteralPath $stage -Destination $app; "
            "Remove-Item -LiteralPath $backup -Recurse -Force; "
            "Remove-Item -LiteralPath $zip -Force; "
            "Start-Process -FilePath $exe "
            "} catch { if ((Test-Path $backup) -and !(Test-Path $app)) { Move-Item -LiteralPath $backup -Destination $app }; exit 1 }"
        ).arg(QCoreApplication::applicationPid())
         .arg(zipPathEscaped)
         .arg(appDirEscaped)
         .arg(exePathEscaped);
        QFile scriptFile(scriptPath);
        if (!scriptFile.open(QIODevice::WriteOnly | QIODevice::Truncate) ||
            scriptFile.write(script.toUtf8()) != script.toUtf8().size()) {
            setStatus(QStringLiteral("Не удалось подготовить установку обновления."));
            return;
        }
        scriptFile.close();
        const bool started = QProcess::startDetached(
            QStringLiteral("powershell.exe"),
            {QStringLiteral("-NoProfile"), QStringLiteral("-ExecutionPolicy"), QStringLiteral("Bypass"),
             QStringLiteral("-File"), scriptPath});
        if (!started) {
            setStatus(QStringLiteral("Не удалось запустить установщик обновления."));
            return;
        }
        setStatus(QStringLiteral("Обновление подготовлено. Приложение перезапустится автоматически."));
        QCoreApplication::quit();
    });
#else
    setStatus(QStringLiteral("Автообновление пока поддерживается только в Windows."));
#endif
}
