TEMPLATE = app

QT += qml quick concurrent location
CONFIG += c++11

SOURCES += main.cpp \
	api.cpp \
	cookiejar.cpp

HEADERS += \
	api.h \
	cookiejar.h

RESOURCES += resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

