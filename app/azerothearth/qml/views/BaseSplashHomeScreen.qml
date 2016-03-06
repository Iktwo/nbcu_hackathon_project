import QtQuick 2.4
import QtGraphicalEffects 1.0 as QGE
import QtQuick.Controls 1.4 as Controls

import "../utils" as Utils

Item {
    id: root

    function close() {
        visible = false;
    }

    Image {
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height

        fillMode: Image.PreserveAspectCrop
        source: "../img/character-both.jpg"
    }

    Image {
        id: _imageLogo
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: __theme.dp(100)

        source: "../img/main-logo.png"
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: __theme.dp(40)
        anchors.right: parent.right
        anchors.rightMargin: __theme.dp(40)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: __theme.dp(60)
        visible: !_baseFormColumn.visible

        Controls.Button {
            width: parent.width / 2
            height: __theme.dp(120)
            text: "Login"

            onClicked: {
                _baseFormColumn.visible = true;
            }
        }

        Controls.Button {
            width: parent.width / 2
            height: __theme.dp(120)
            text: "Sign Up"

            onClicked: {
                root.visible = false;
            }
        }
    }

    BaseFormColumn {
        id: _baseFormColumn

        onBackClicked: {
            _baseFormColumn.visible = false;
        }

        visible: false
        actionButtonText: "Login"
        onActionButtonClicked: {
            _parse.loginUser(usernameTextField.text,
                             passwordTextField.text,
                             function(result) {
                                 if (result.status == 0) {
                                     // failed
                                     var msg = "";
                                     if (result.errorString === _parse.errorStringPasswordIncorrect) {
                                         msg = "Password is incorrect";
                                     }
                                     __dialog.showWithMessage(msg);
                                 } else {
                                     __dialog.showWithMessage("Welcome back to AzerothEarth, " + usernameTextField.text + ".\nGAME ON.");
                                     root.close();
                                 }
                             });
        }
    }
}

