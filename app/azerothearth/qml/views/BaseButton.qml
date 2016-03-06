import QtQuick 2.0

Rectangle {
    id: root

    signal clicked;
    property color themeColor: "#c7c9b4"
    property alias text: _label.text

    height: __theme.dp(120)
    color: "transparent"

    border {
        width: __theme.dp(2)
        color: "#604411"
        Behavior on color {
            ColorAnimation { duration: 100 }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked();
    }

    Image {
        anchors.fill: parent
        source: "../img/pattern-leather.jpg"
        fillMode: Image.Tile
        opacity: 0.2
    }

    Label {
        id: _label
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: __theme.dp(20)
        anchors.topMargin: __theme.dp(16)
        anchors.bottomMargin: __theme.dp(10)

        font.pixelSize: __theme.dp(root.height*0.40)

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.capitalization: Font.AllUppercase


        color: root.themeColor
    }
}

