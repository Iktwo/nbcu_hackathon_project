import QtQuick 2.0

Rectangle {
    id: root

    function generateColor() {
        return '#'+Math.floor(Math.random()*16777215).toString(16);;
    }

    anchors.fill: parent
    color: generateColor();
    opacity: 0.5
    visible: superRoot.showFills

    onVisibleChanged: {
        if (visible) {
            color = generateColor();
        }
    }

    border { width: this === superRoot.activeObject ? 4 : 1; color: "#ffffff" }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: "transparent"
        border { width: root.border.width; color: "#00FEAA" }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: superRoot.activeObject = root
    }
}
