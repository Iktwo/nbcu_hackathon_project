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

    BaseFormColumn {

        onBackClicked: {
            root.backClicked();
        }

        actionButtonText: qsTr("Sign Up");
        onActionButtonClicked: {
            var userObject = _parse.buildUserObject(usernameTextField.text, passwordTextField.text);
            userObject.characterType = root.characterType || "CHARACTERTYPE_UNKNOWN";

            if (__positionSource.coordinate) {
                userObject.lat = __positionSource.coordinate.latitude
                userObject.lng = __positionSource.coordinate.longitude
            }

            _parse.registerUser(userObject, function(result) {
                if (result.errorString === _parse.errorStringUsernameTaken) {
                    __dialog.showWithMessage("Username is not available.")
                    usernameTextField.error = true;
                } else if (result.errorString === _parse.errorStringUsernameNotDefined
                           || result.errorString === _parse.errorStringUsernameTooShort) {
                    usernameTextField.error = true;
                    __dialog.showWithMessage("Username must be at least 3 characters in length.")
                } else if (result.errorString === _parse.errorStringPasswordNotDefined
                           || result.errorString === _parse.errorStringPasswordTooShort) {
                    passwordTextField.error = true;
                    __dialog.showWithMessage("Password must be at least 3 characters in length.")
                }
                else {
                    root.registrationSuccessful(_textFieldUsername.text);
                }
            });
        }
    }

}

