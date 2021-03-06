import QtQuick 2.4
import QtGraphicalEffects 1.0 as QGE
import QtQuick.Controls 1.4 as Controls
import QtQuick.Particles 2.0

import "../utils" as Utils
import "../"

Item {
    id: root

    function close() {
        _stateGroup.state = "signUp"
    }

    function reset() {
        _stateGroup.state = "ready";
    }

    Utils.ClickGuard { }

    StateGroup {
        id: _stateGroup
        states: [
            State {
                name: "ready"
                PropertyChanges {
                    target: _imageLogo
                    anchors.bottomMargin: __theme.dp(400)
                }
                PropertyChanges {
                    target: _fadeBottom
                    height: 0.65*root.height
                    opacity: 1.0
                }
                PropertyChanges {
                    target: _mouseAreaInitial
                    visible: false
                }
                PropertyChanges {
                    target: _columnMainTwoButtons
                    anchors.bottomMargin: __theme.dp(60)
                }
            },
            State {
                name: "login"
                extend: "ready"
                PropertyChanges {
                    target: _imageLogo
                    anchors.bottomMargin: __theme.dp(550)
                }
                PropertyChanges {
                    target: _baseFormColumn
                    anchors.bottomMargin: __theme.dp(60)
                    visible: true
                }
                PropertyChanges {
                    target: _columnMainTwoButtons
                    anchors.bottomMargin: -1*__theme.dp(100)
                    opacity: 0.0
                }
            },
            State {
                name: "signUp"
                PropertyChanges {
                    target: root
                    opacity: 0.0
                    visible: false
                }
                StateChangeScript {
                    script: {
                        _ListViewImages.currentIndex = 1;
                    }
                }
            }
        ]
        transitions: [
            Transition {
                from: ""
                to: "ready"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation {
                            target: _imageLogo
                            property: "anchors.bottomMargin"
                            duration: 750
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _columnMainTwoButtons
                            properties: "anchors.bottomMargin"
                            duration: 750
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _fadeBottom
                            properties: "height"
                            duration: 750
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _fadeBottom
                            properties: "opacity"
                            duration: 650
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            },
            Transition {
                from: "ready"
                to: "login"
                SequentialAnimation {
                    PropertyAction {
                        target: _baseFormColumn
                        property: "visible"
                    }
                    ParallelAnimation {
                        NumberAnimation {
                            target: _columnMainTwoButtons
                            properties: "opacity"
                            duration: 450
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _imageLogo
                            properties: "anchors.bottomMargin"
                            duration: 450
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _columnMainTwoButtons
                            properties: "anchors.bottomMargin"
                            duration: 450
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _baseFormColumn
                            properties: "anchors.bottomMargin"
                            duration: 450
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            },
            Transition {
                from: "login"
                to: "ready"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation {
                            target: _imageLogo
                            properties: "anchors.bottomMargin"
                            duration: 450
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _columnMainTwoButtons
                            properties: "opacity"
                            duration: 450
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _columnMainTwoButtons
                            properties: "anchors.bottomMargin"
                            duration: 450
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _baseFormColumn
                            properties: "anchors.bottomMargin"
                            duration: 450
                            easing.type: Easing.OutCubic
                        }
                    }
                    PropertyAction {
                        target: _baseFormColumn
                        property: "visible"
                    }
                }
            },
            Transition {
                from: "*"
                to: "signUp"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation {
                            target: _imageLogo
                            property: "anchors.bottomMargin"
                            duration: 750
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _columnMainTwoButtons
                            properties: "anchors.bottomMargin"
                            duration: 750
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _fadeBottom
                            properties: "height"
                            duration: 750
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _fadeBottom
                            properties: "opacity"
                            duration: 650
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: root
                            properties: "opacity"
                            duration: 650
                            easing.type: Easing.OutCubic
                        }
                    }
                    PropertyAction {
                        target: root
                        property: "visible"
                    }
                }
            }
        ]
    }

    MouseArea {
        id: _mouseAreaInitial
        anchors.fill: parent
        onClicked: {
            _stateGroup.state = "ready";
        }
    }

    Image {
        id: _imageCharacters
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height

        fillMode: Image.PreserveAspectCrop
        source: "../img/character-both.jpg"
    }

    Image {
        id: _imageFlameSmoke
        anchors.fill: parent
        source: "../img/bg-flamesmoke.jpg"
        opacity: 0.85
    }

    QGE.Blend {
        id: _imageBlend
        anchors.fill: parent
        source: _imageCharacters
        foregroundSource: _imageFlameSmoke

        mode: "difference"
    }


    FadeBottom {
        id: _fadeBottom
        anchors.fill: parent
        opacity: 0.0
    }

    Image {
        id: _imageLogo
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: __theme.dp(100)
        width: 0.8*parent.width
        fillMode: Image.PreserveAspectFit

        source: "../img/logo-warcraft-azerothearth.png"
    }

    Column {
        id: _columnMainTwoButtons
        anchors.left: parent.left
        anchors.leftMargin: __theme.dp(40)
        anchors.right: parent.right
        anchors.rightMargin: __theme.dp(40)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -1*height
        spacing: __theme.dp(40)

        BaseButton {
            width: parent.width - parent.spacing/2
            height: __theme.dp(120)
            text: "Login"

            onClicked: {
                //                _baseFormColumn.visible = true;
                _stateGroup.state = "login";
            }
        }

        BaseButton {
            width: parent.width - parent.spacing/2
            height: __theme.dp(120)
            text: "Sign Up"

            onClicked: {
                _stateGroup.state = "signUp";
            }
        }
    }

    BaseFormColumn {
        id: _baseFormColumn
        anchors.bottomMargin: -1*__theme.dp(height)
        visible: false

        onBackClicked: {
            _stateGroup.state = "ready";
        }

        actionButtonText: "Login"
        onActionButtonClicked: {
            _parse.loginUser(usernameTextField.text,
                             passwordTextField.realText,
                             function(result) {
                                 if (result.status == 0) {
                                     // failed
                                     var msg = "Login failed";
                                     if (result.errorString === _parse.errorStringPasswordIncorrect) {
                                         msg = "Password is incorrect";
                                     }
                                     __dialog.showWithMessage(msg);
                                 } else {
                                     __dialog.showWithMessage("Welcome back to AzerothEarth, " + usernameTextField.text + ".\n\nGAME ON.");
                                     root.close();
                                 }
                             });
        }
    }
}

