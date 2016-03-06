import QtQuick 2.4
import QtGraphicalEffects 1.0 as QGE

Item {
    id: root
    anchors.top: parent.top
    width: parent.width
    height: 0.35*parent.height

    QGE.LinearGradient {
        anchors.fill: parent
        start: Qt.point(width / 2, 0);
        end: Qt.point(width / 2, height)

        gradient: Gradient {
            GradientStop {
                color: "#000000"
                position: 0.0
            }
            GradientStop {
                color: "transparent"
                position: 1.0
            }
        }
    }
}

