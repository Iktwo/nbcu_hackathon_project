#include "imageshare.h"

#include <QDebug>

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#endif


ImageShare::ImageShare(QObject *parent) : QObject(parent)
{

}

void ImageShare::shareImage()
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/azerothearth/MainActivity",
                                              "shareImage", "()V");
#else
    qDebug() << Q_FUNC_INFO << "not implemented yet";
#endif
}
