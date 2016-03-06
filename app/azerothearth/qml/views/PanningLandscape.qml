import QtQuick 2.4

Flickable {
    id: _flickableBackground
    anchors.fill: parent
    contentWidth: _imageLandscape.width

    Image {
        id: _imageLandscape
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        source: "../img/landscape-azerothearth.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    SequentialAnimation {
        running: true
        loops: Animation.Infinite
        PauseAnimation {
            duration: 1000
        }
        SmoothedAnimation {
            target: _flickableBackground
            property: "contentX"
            from: 0; to: _flickableBackground.contentWidth - width
            velocity: 16
        }
        PauseAnimation {
            duration: 4000
        }
        SmoothedAnimation {
            target: _flickableBackground
            property: "contentX"
            to: 0; from: _flickableBackground.contentWidth - width
            velocity: 16
        }
        PauseAnimation {
            duration: 3000
        }
    }
}

