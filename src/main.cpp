#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "UpdateService.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("Message");
    app.setOrganizationName("Message");
    app.setApplicationVersion("0.3.0");

    QQuickStyle::setStyle("Basic");

    UpdateService updater;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("updateService", &updater);
    engine.loadFromModule("Message.Desktop", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
