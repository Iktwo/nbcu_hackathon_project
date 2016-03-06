import QtQuick 2.4

Item {
    id: root

    property bool isOpen: false

    anchors.fill: parent

    function showWithMessage(message) {
        _labelMessage.text = message;
        isOpen = true;
    }

    function hide() {
        isOpen = false;
    }

    StateGroup {
        states: [
            State {
                name: "hidden"
                when: !root.isOpen
                PropertyChanges {
                    target: root
                    visible: false
                }
                PropertyChanges {
                    target: _rectangleMessage
                    opacity: 0.0
                    anchors.verticalCenterOffset: __theme.dp(0.5*root.height)
                }
                PropertyChanges {
                    target: _mouseArea
                    opacity: 0.0
                    visible: false
                }
            },
            State {
                name: "visible"
                when: root.isOpen
                PropertyChanges {
                    target: root
                    visible: true
                }
                PropertyChanges {
                    target: _rectangleMessage
                    opacity: 1.0
                    anchors.verticalCenterOffset: 0.0
                }
                PropertyChanges {
                    target: _mouseArea
                    opacity: 1.0
                    visible: true
                }
            }
        ]
        transitions: [
            Transition {
                from: "visible"
                to: "hidden"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation {
                            target: _mouseArea
                            property: "opacity"
                            duration: 350
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _rectangleMessage
                            property: "opacity"
                            duration: 350
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _rectangleMessage
                            property: "anchors.verticalCenterOffset"
                            duration: 350
                            easing.type: Easing.OutCubic
                        }
                    }
                    ParallelAnimation {
                        PropertyAction {
                            target: _mouseArea
                            property: "visible"
                        }
                        PropertyAction {
                            target: root
                            property: "visible"
                        }
                    }
                    ScriptAction {
                        script: {
                            _labelMessage.text = "";
                        }
                    }
                }
            },
            Transition {
                from: "hidden"
                to: "visible"
                SequentialAnimation {
                    PropertyAction {
                        target: root
                        property: "visible"
                    }
                    PropertyAction {
                        target: _mouseArea
                        property: "visible"
                    }
                    ParallelAnimation {
                        NumberAnimation {
                            target: _mouseArea
                            property: "opacity"
                            duration: 350
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _rectangleMessage
                            property: "opacity"
                            duration: 350
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: _rectangleMessage
                            property: "anchors.verticalCenterOffset"
                            duration: 350
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        ]
    }

    MouseArea {
        id: _mouseArea

        anchors.fill: parent
        onClicked: {
            root.hide();
        }
        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.5
        }
    }

    Rectangle {
        id: _rectangleMessage

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: __theme.dp(50)
        anchors.rightMargin: __theme.dp(50)
        anchors.verticalCenter: parent.verticalCenter

        height: _labelMessage.height + __theme.dp(200)
        color: "#000000"

        gradient: Gradient {
            GradientStop {
                position: 0.25
                color: "#664f10"
            }
            GradientStop {
                position: 1.0
                color: "#000000"
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.65

            border.width: 2
            border.color: "#604411"
        }

        Image {
            anchors.fill: parent
            fillMode: Image.Tile
            source: "../img/pattern-leather.jpg"
            opacity: 0.25
        }

        Label {
            id: _labelMessage
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: __theme.dp(30)
            anchors.rightMargin: __theme.dp(30)
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: __theme.dp(42)

            color: "#c7c9b4"
        }
    }
}

