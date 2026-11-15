#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("Message");
    app.setOrganizationName("Message");
    app.setApplicationVersion("0.2.0");

    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;
    engine.loadFromModule("Message.Desktop", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
