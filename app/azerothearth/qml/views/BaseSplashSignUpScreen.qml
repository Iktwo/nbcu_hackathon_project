import QtQuick 2.4
import QtGraphicalEffects 1.0 as QGE

import "../utils" as Utils

Item {
    id: root

    signal moveListIndexTo(int index);

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
            root.moveListIndexTo(0);
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
            root.moveListIndexTo(2);
        }
    }

    Rectangle {
        property int distanceFromCenter: Math.abs((_ListViewImages.contentWidth / 2) - _ListViewImages.contentX + _ListViewImages.width / 2);
        anchors.fill: parent
        color: "#000000"
        opacity: (Math.abs(root.width - distanceFromCenter) / root.width) * 0.6
    }
}

