import QtQuick 2.4
import QtQuick.Controls 1.4 as Controls
import QtQuick.Controls.Styles 1.4 as ControlStyles

import AzerothEarth 1.0 as AZE

Column {
    id: root

    signal backClicked

    property alias actionButtonText: _buttonSignUp.text
    signal actionButtonClicked

    property alias usernameTextField: _textFieldUsername
    property alias passwordTextField: _textFieldPassword

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
        echoMode: TextInput.Password
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        height: __theme.dp(120)

        Controls.Button {
            id: _buttonSignUp
            width: parent.width / 2
            height: parent.height

            onClicked: root.actionButtonClicked()
        }

        Controls.Button {
            width: parent.width / 2
            height: parent.height
            text: "Back"

            onClicked: {
                root.backClicked();
            }
        }
    }

}

