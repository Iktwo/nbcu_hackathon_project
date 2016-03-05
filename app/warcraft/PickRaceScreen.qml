import QtQuick 2.0

Rectangle {
    id: root

    signal selected

    ListView {
        id: _ListViewImages

        anchors.fill: parent

        cacheBuffer: width * 3
        snapMode: ListView.SnapOneItem
        currentIndex: 1
        highlightRangeMode: ListView.StrictlyEnforceRange

        model: [
            "images/orc.jpg",
            "images/background.jpg",
            "images/human.jpg"
        ]

        orientation: ListView.Horizontal
        delegate: Image {
            height: _ListViewImages.height
            width: _ListViewImages.width

            source: modelData

            fillMode: Image.PreserveAspectCrop
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.selected()
    }
}
