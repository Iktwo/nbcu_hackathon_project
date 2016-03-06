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

    Column {
        id: _itemText
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: __theme.dp(80)

        spacing: __theme.dp(30)

        Label {
            id: _labelDescription
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: __theme.dp(60)
            anchors.rightMargin: anchors.leftMargin
            wrapMode: Text.WordWrap

            horizontalAlignment: Text.AlignHCenter

            text: "Choose your side"
            font.capitalization: Font.AllUppercase
            color: "#c7c9b4"
        }
        Label {
            id: _labelOrc
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: __theme.dp(60)
            anchors.rightMargin: anchors.leftMargin
            wrapMode: Text.WordWrap
            font.pixelSize: __theme.dp(42)

            horizontalAlignment: Text.AlignHCenter

            text: "Swipe right\nto join the Orc Army"
            font.capitalization: Font.AllUppercase
            color: "#ef492f" //"#c7c9b4"
        }

        Label {
            id: _labelHuman
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: __theme.dp(60)
            anchors.rightMargin: anchors.leftMargin
            wrapMode: Text.WordWrap
            font.pixelSize: __theme.dp(42)

            horizontalAlignment: Text.AlignHCenter

            text: "Swipe left\nto join the Human Collective"
            font.capitalization: Font.AllUppercase
            color: "#387ee5" //"#c7c9b4"
        }
    }

    MouseArea {
        id: _mouseAreaLeft
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: _itemText.top
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
        anchors.bottom: _itemText.top
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

