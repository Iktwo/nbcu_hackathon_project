import QtQuick 2.4
import QtGraphicalEffects 1.0 as QGE
import "../utils" as Utils

Rectangle {
    id: root

    signal selected

    ListView {
        id: _ListViewImages

        function resetToInitialState() {
            currentIndex = 1;
        }

        anchors.fill: parent

        cacheBuffer: width * 3
        snapMode: ListView.SnapOneItem
        currentIndex: 1
        highlightRangeMode: ListView.StrictlyEnforceRange
        interactive: false
        highlightMoveDuration: 320

        Component {
            id: _componentSignUp_Orc

            BaseCharacterSignUpScreen {
                imageSource: "../img/character-orc.jpg"
                characterType: "CHARACTERTYPE_ORC"

                onBackClicked: {
                    _ListViewImages.resetToInitialState();
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
            }
        }

        Component {
            id: _componentHome

            Item {
                Image {
                    anchors.fill: parent
                    sourceSize.width: parent.width
                    sourceSize.height: parent.height

                    fillMode: Image.PreserveAspectCrop
                    source: "../img/character-both.jpg"

                    layer.enabled: true
                    layer.effect: QGE.FastBlur {
                        radius: _mouseAreaLeft.pressed || _mouseAreaRight.pressed ? 15 : 0
                        Behavior on radius {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }

                Image {
                    id: _imageLogo
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: __theme.dp(100)

                    source: "../img/main-logo.png"
                }

                MouseArea {
                    id: _mouseAreaLeft
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: _imageLogo.top
                    width: parent.width / 2

                    Utils.Fill { }

                    onClicked: {
                        _ListViewImages.currentIndex = 0;
                    }
                }

                MouseArea {
                    id: _mouseAreaRight
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: _imageLogo.top
                    width: parent.width / 2

                    Utils.Fill { }

                    onClicked: {
                        _ListViewImages.currentIndex = 2;
                    }
                }

                Rectangle {
                    property int distanceFromCenter: Math.abs((_ListViewImages.contentWidth / 2) - _ListViewImages.contentX + _ListViewImages.width / 2);
                    anchors.fill: parent
                    color: "#000000"
                    opacity: (Math.abs(root.width - distanceFromCenter) / root.width) * 0.6
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
}
