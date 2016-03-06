import QtQuick 2.4
import QtQuick.Controls 1.4 as Controls

Controls.TextField {
    id: root
    anchors.left: parent.left
    anchors.right: parent.right

    height: __theme.dp(120)
    font.pixelSize: __theme.dp(72)

    property bool error: false

    Rectangle {
        anchors.fill: parent
        anchors.margins: border.width
        color: "transparent"
        border.width: 4
        border.color: "#FF0000"
        visible: root.error
    }
}
