import QtQuick 2.4
import QtGraphicalEffects 1.0 as QGE
import "../utils" as Utils

Rectangle {
    id: root

    signal closing

    function close() {
        visible = false;
        enabled = false
    }

    function open() {
        visible = true;
        enabled = true
    }

    function reset() {
        _splashHomeScreen.visible = true;
    }

    ListView {
        id: _ListViewImages
        // This is for sign-up

        function resetToInitialState() {
            currentIndex = 1;
        }

        anchors.fill: parent

        cacheBuffer: width * 3
        snapMode: ListView.SnapOneItem
        currentIndex: 1
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 320

        Component {
            id: _componentSignUp_Orc

            BaseCharacterSignUpScreen {
                imageSource: "../img/character-orc.jpg"
                characterType: "CHARACTERTYPE_ORC"

                onBackClicked: {
                    _ListViewImages.resetToInitialState();
                }

                onRegistrationSuccessful: {
                    root.closing();
                }
            }
        }

        Component {
            id: _componentSignUp_Human

            BaseCharacterSignUpScreen {
                imageSource: "../img/character-human.jpg"
                characterType: "CHARACTERTYPE_HUMAN"

                onBackClicked: {
                    _ListViewImages.resetToInitialState();
                }

                onRegistrationSuccessful: {
                    root.closing();
                }
            }
        }

        Component {
            id: _componentHome

            BaseSplashSignUpScreen {
                onMoveListIndexTo: {
                    _ListViewImages.currentIndex = index;
                }
            }
        }

        model: [
            _componentSignUp_Orc,
            _componentHome,
            _componentSignUp_Human
        ]

        orientation: ListView.Horizontal
        delegate: Item {
            width: ListView.view.width
            height: ListView.view.height

            Loader {
                anchors.fill: parent
                sourceComponent: model.modelData
            }
        }
    }

    BaseSplashHomeScreen {
        id: _splashHomeScreen
        anchors.fill: parent
    }
}
