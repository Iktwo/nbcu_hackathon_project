#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include "api.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Api>("api", 1, 0, "Api");

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}



