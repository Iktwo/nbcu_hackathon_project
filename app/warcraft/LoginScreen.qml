import QtQuick 2.0

Rectangle {
    id: root

    signal loggedIn

    Text {
        anchors.centerIn: parent
        text: "LoginScreen"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.loggedIn()
    }
}
