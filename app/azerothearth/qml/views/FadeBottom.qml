import QtQuick 2.4
import QtGraphicalEffects 1.0 as QGE

Item {
    id: root
    anchors.bottom: parent.bottom
    width: parent.width
    height: 0.35*parent.height

    QGE.LinearGradient {
        anchors.fill: parent
        start: Qt.point(width / 2, height)
        end: Qt.point(width / 2, 0);

        gradient: Gradient {
            GradientStop {
                color: "transparent"
                position: 1.0
            }
            GradientStop {
                color: "#000000"
                position: 0.0
            }
        }
    }
}

