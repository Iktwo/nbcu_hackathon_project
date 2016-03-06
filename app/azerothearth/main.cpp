#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlExtensionPlugin>
#include <QQmlContext>
#include <qqml.h>
#include <QCursor>
#include <QPixmap>
#include <QDebug>
#include <QWidget>
#include <QScreen>

#include "src/screenvalues.h"
#include "src/imageshare.h"

#define QML_DEVELOPMENT "qrc:/qml/dev.qml"
#define SIM false

#if defined(Q_OS_IOS)
//Q_IMPORT_PLUGIN(PlatformPlugin)
//Q_IMPORT_PLUGIN(ModelsPlugin)
#endif

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#endif

static QObject *screen_values_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    ScreenValues *screenValues = new ScreenValues();
    return screenValues;
}

static QObject *image_share_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    ImageShare *imageShare= new ImageShare();
    return imageShare;
}


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QString mainQml = QStringLiteral(QML_DEVELOPMENT);

    qmlRegisterSingletonType<ScreenValues>("AzerothEarth", 1, 0, "ScreenValues", screen_values_provider);
    qmlRegisterSingletonType<ImageShare>("AzerothEarth", 1, 0, "ImageShare", image_share_provider);

    float dpi = QGuiApplication::primaryScreen()->physicalDotsPerInch();

    /// TODO: Q_OS_BLACKBERRY || Q_OS_WINPHONE

#ifdef Q_OS_IOS
    mainQml = QStringLiteral("qrc:/qml/main_ios.qml");
#elif defined(Q_OS_ANDROID)

    QAndroidJniObject qtActivity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
    QAndroidJniObject resources = qtActivity.callObjectMethod("getResources", "()Landroid/content/res/Resources;");
    QAndroidJniObject displayMetrics = resources.callObjectMethod("getDisplayMetrics", "()Landroid/util/DisplayMetrics;");
    dpi = displayMetrics.getField<float>("density");

    mainQml = QStringLiteral("qrc:/qml/main_android.qml");
#elif SIM
    QCursor cursor(QPixmap(":/qml/img/sim/cursor-default.png"));
    app.setOverrideCursor(cursor);
    mainQml = QStringLiteral("qrc:/qml/simfinger.qml");
#endif

    engine.rootContext()->setContextProperty("$", QVariant::fromValue(dpi));
    engine.load(QUrl(mainQml));

    return app.exec();
}
