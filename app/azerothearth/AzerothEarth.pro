TEMPLATE = app

QT += qml quick widgets sql multimedia network

SOURCES += main.cpp \
    src/screenvalues.cpp \
    src/imageshare.cpp

RESOURCES += qml.qrc

osx {
    QMAKE_MAC_SDK = macosx10.9
}


ios {
    # isa = XCBuildConfiguration;
    # ASSETCATALOG_COMPILER_APPICON_NAME = "AppIcon";

#    BUNDLE_DATA.files = $$PWD/ios/LaunchScreen.xib \
#    $$PWD/ios/Images.xcassets \
#    $$PWD/ios/Default-568h@2x.png \
#    $$PWD/ios/Default-480h@2x.png
#    $$PWD/ios/Default.png


    QMAKE_BUNDLE_DATA += BUNDLE_DATA
    QMAKE_INFO_PLIST = $$PWD/ios/Info.plist

    LIBS += -framework MobileCoreServices
    LIBS += -framework MessageUI
    LIBS += -framework iAd
    LIBS += -framework AudioToolbox
}

android {
    QT += androidextras
}

include(deployment.pri)

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml \
    android/src/azerothearth/Main.java \
    qml/views/TutorialSheet.qml

lupdate_only{
    SOURCES = qml/*.qml \
        qml/android/*.qml
}

HEADERS += \
    src/screenvalues.h \
    src/imageshare.h

DISTFILES += \
    src/ImageShare.qml \
    android/src/com/azerothearth/MainActivity.java
