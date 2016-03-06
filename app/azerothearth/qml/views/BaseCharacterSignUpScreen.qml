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

    FadeTop {
        id: _fadeTop
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Label {
        id: _labelDescription
        anchors.left: _baseFormColumn.left
        anchors.right: _baseFormColumn.right
        anchors.bottom: _baseFormColumn.top
        anchors.top: parent.top
        anchors.topMargin: __theme.dp(40)
        wrapMode: Text.WordWrap
        font.pixelSize: __theme.dp(64)

        horizontalAlignment: Text.AlignLeft

        text: "Join the\n" + (root.characterType == "CHARACTERTYPE_ORC" ? "Orc Army" : "Human Collective")
        font.capitalization: Font.AllUppercase
        color: "#c7c9b4"
    }

    BaseFormColumn {
        id: _baseFormColumn

        onBackClicked: {
            root.backClicked();
        }

        actionButtonText: qsTr("Sign Up");
        onActionButtonClicked: {
            var userObject = _parse.buildUserObject(usernameTextField.text, passwordTextField.realText);
            userObject.characterType = root.characterType || "CHARACTERTYPE_UNKNOWN";


            if (__positionSource.coordinate) {
                userObject.location = {
                    "__type" : "GeoPoint",
                    "latitude" : __positionSource.coordinate.latitude,
                    "longitude" : __positionSource.coordinate.longitude
                }
            }

            _parse.registerUser(userObject, function(result) {
                if (result.errorString === _parse.errorStringUsernameTaken) {
                    __dialog.showWithMessage("Username is not available.")
                    usernameTextField.error = true;
                } else if (result.errorString === _parse.errorStringUsernameNotDefined
                           || result.errorString === _parse.errorStringUsernameTooShort) {
                    usernameTextField.error = true;
                    __dialog.showWithMessage("Username must be at least 4 characters in length.")
                } else if (result.errorString === _parse.errorStringPasswordNotDefined
                           || result.errorString === _parse.errorStringPasswordTooShort) {
                    passwordTextField.error = true;
                    __dialog.showWithMessage("Password must be at least 4 characters in length.")
                }
                else {

                    var characterMessage = root.characterType === "CHARACTERTYPE_ORC" ? "Orc Army" : "Human Collective"
                    __dialog.showWithMessage("Hello, " + usernameTextField.text + ".\nWelcome to the " + characterMessage);
                    root.registrationSuccessful(usernameTextField.text);
                }
            });
        }
    }

}

