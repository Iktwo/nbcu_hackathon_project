import QtQuick 2.4

Item {
    id: root

    anchors.fill: parent
    visible: false

    function showWithMessage(message) {
        _labelMessage.text = message;
        visible = true;
    }

    function hide() {
        visible = false;
        _labelMessage.text = "";
    }

    MouseArea {
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
        anchors.leftMargin: __theme.dp(80)
        anchors.rightMargin: __theme.dp(80)
        anchors.verticalCenter: parent.verticalCenter

        height: __theme.dp(400)
        radius: __theme.dp(40)
        color: "#000000"

        Label {
            id: _labelMessage
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: __theme.dp(30)
            anchors.rightMargin: __theme.dp(30)
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            color: "#ffffff"
        }
    }
}

