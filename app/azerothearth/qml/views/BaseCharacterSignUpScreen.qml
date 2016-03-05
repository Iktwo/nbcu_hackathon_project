import QtQuick 2.4
import QtQuick.Controls 1.4 as Controls
import QtQuick.Controls.Styles 1.4 as ControlStyles

import AzerothEarth 1.0 as AZE

Item {
    id: root

    signal backClicked

    property string characterType: ""
    property alias imageSource: _image.source

    Image {
        id: _image
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: __theme.dp(100)

        color: "#00FEAA"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.backClicked();
            }
        }
    }

    Column {
        anchors.left: parent.left
        anchors.leftMargin: __theme.dp(40)
        anchors.right: parent.right
        anchors.rightMargin: __theme.dp(40)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: __theme.dp(60)

        spacing: __theme.dp(40)

        BaseTextField {
            id: _textFieldUsername
            placeholderText: "Username"
        }

        BaseTextField {
            id: _textFieldPassword
            placeholderText: "Password"
        }

        Controls.Button {
            id: _buttonSignUp
            anchors.left: parent.left
            anchors.right: parent.right
            height: __theme.dp(120)

            text: "Sign Up"
        }
    }
}

