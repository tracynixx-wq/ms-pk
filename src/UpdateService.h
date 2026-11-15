#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QUrl>

class UpdateService final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(bool updateAvailable READ updateAvailable NOTIFY updateAvailableChanged)
    Q_PROPERTY(QString latestVersion READ latestVersion NOTIFY updateAvailableChanged)

public:
    explicit UpdateService(QObject *parent = nullptr);
    QString status() const { return m_status; }
    bool updateAvailable() const { return m_updateAvailable; }
    QString latestVersion() const { return m_latestVersion; }

    Q_INVOKABLE void checkForUpdates();
    Q_INVOKABLE void downloadAndInstall();

signals:
    void statusChanged();
    void updateAvailableChanged();

private:
    void setStatus(const QString &status);
    QNetworkAccessManager m_network;
    QUrl m_assetUrl;
    QString m_status = QStringLiteral("Проверка обновлений не выполнялась");
    QString m_latestVersion;
    bool m_updateAvailable = false;
};
