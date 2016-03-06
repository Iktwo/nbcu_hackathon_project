import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root

    property int baseSize: height / 10
    property color smokeColor: colors.gold
    readonly property var colors: { "gold": "#f1c40f", "mineral": "#7f8c8d", "wood": "#d35400"}

    width: 350
    height: 350

    ParticleSystem {
        anchors.fill: parent

        Emitter {
            id: _Emitter

            property int area: root.width

            anchors.centerIn: parent
            group: "B"

            emitRate: 100
            lifeSpan: 1500
            size: area * 0.4
            endSize: area / 6
            sizeVariation: area / 2
            acceleration: PointDirection { y: -baseSize }
            velocity: AngleDirection { angle: 270; magnitude: _Emitter.area / 2; angleVariation: baseSize * 1.4; magnitudeVariation: _Emitter.area / 12 }
        }

        ImageParticle {
            groups: ["B"]
            anchors.fill: parent
            source: "qrc:///particleresources/star.png"
            color: root.smokeColor
            colorVariation: 0.15
        }
    }
}
