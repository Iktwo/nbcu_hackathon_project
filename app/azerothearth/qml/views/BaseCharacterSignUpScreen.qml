import QtQuick 2.4
import QtQuick.Controls 1.4 as Controls
import QtQuick.Controls.Styles 1.4 as ControlStyles

import AzerothEarth 1.0 as AZE

Item {
    id: root

    signal backClicked
    signal registrationSuccessful(string username)

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

    MouseArea {
        anchors.fill: parent
        onClicked: {
            _rectangleMessage.visible = false;
            _labelMessage.text = "";
        }
        visible: _rectangleMessage.visible
        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.5
        }

        z: 2
    }

    Rectangle {
        id: _rectangleMessage

        function showWithMessage(message) {
            _labelMessage.text = message;
            visible = true;
        }

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: __theme.dp(80)
        anchors.rightMargin: __theme.dp(80)
        anchors.verticalCenter: parent.verticalCenter

        height: __theme.dp(400)
        radius: __theme.dp(40)
        color: "#000000"
        visible: false


        Label {
            id: _labelMessage
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: __theme.dp(30)
            anchors.rightMargin: __theme.dp(30)
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.WordWrap
            color: "#ffffff"
        }

        z: 3
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
            echoMode: TextInput.Password
        }

        Controls.Button {
            id: _buttonSignUp
            anchors.left: parent.left
            anchors.right: parent.right
            height: __theme.dp(120)

            text: "Sign Up"

            onClicked: {
                var userObject = _parse.buildUserObject(_textFieldUsername.text, _textFieldPassword.text);
                userObject.characterType = root.characterType || "CHARACTERTYPE_UNKNOWN";

                if (__positionSource.coordinate) {
                    userObject.coordinate = {
                        latitude: __positionSource.coordinate.latitude,
                        longitude: __positionSource.coordinate.longitude
                    }
                }

                _parse.registerUser(userObject, function(result) {
                    if (result.errorString === _parse.errorStringUsernameTaken) {
                        _rectangleMessage.showWithMessage("Username is not available.")
                        _textFieldUsername.error = true;
                    } else if (result.errorString === _parse.errorStringUsernameNotDefined
                               || result.errorString === _parse.errorStringUsernameTooShort) {
                        _textFieldUsername.error = true;
                        _rectangleMessage.showWithMessage("Username must be at least 3 characters in length.")
                    } else if (result.errorString === _parse.errorStringPasswordNotDefined
                               || result.errorString === _parse.errorStringPasswordTooShort) {
                        _textFieldPassword.error = true;
                        _rectangleMessage.showWithMessage("Password must be at least 3 characters in length.")
                    }
                    else {
                        root.registrationSuccessful(_textFieldUsername.text);
                    }
                });
            }
        }
    }
}

