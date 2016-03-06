import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root

    width: 320
    height: 480

    ParticleSystem {
        anchors.fill: parent

        Turbulence {
            anchors.fill: parent
            enabled: true
            height: (parent.height / 2) - 4
            width: parent.width
            x: parent. width / 4
            strength: 32

            NumberAnimation on strength{ from: 16; to: 64; easing.type: Easing.InOutBounce; duration: 1800; loops: -1 }
        }

        ImageParticle {
            groups: ["smoke"]
            source: "qrc:///particleresources/glowdot.png"
            color: "#11111111"
            colorVariation: 0
        }

        ImageParticle {
            groups: ["flame"]
            source: "qrc:///particleresources/glowdot.png"
            color: "#11ff400f"
            colorVariation: 0.1
        }

        Emitter {
            id: flame

            property int area: 90

            anchors.centerIn: parent
            group: "flame"

            emitRate: 120
            lifeSpan: 1200
            size: area
            endSize: area / 6
            sizeVariation: area / 2
            acceleration: PointDirection { y: -40 }
            velocity: AngleDirection { angle: 270; magnitude: flame.area / 2; angleVariation: 22; magnitudeVariation: flame.area / 12 }
        }

        TrailEmitter {
            id: smoke1

            width: root.width
            height: root.height/2
            group: "smoke"
            follow: "flame"

            emitRatePerParticle: 1
            lifeSpan: 2400
            lifeSpanVariation: 400
            size: flame.area / 3
            endSize: flame.area / 6
            sizeVariation: flame.area / 5
            acceleration: PointDirection { y: -40 }
            velocity: AngleDirection { angle: 270; magnitude: flame.area / 2; angleVariation: 22; magnitudeVariation: magnitude / 4 }
        }

        TrailEmitter {
            id: smoke2
            width: root.width
            height: root.height/2 - 20
            group: "smoke"
            follow: "flame"

            emitRatePerParticle: 4
            lifeSpan: 2400
            size: flame.area / 1.5
            endSize: flame.area / 1.8
            sizeVariation: 12
            acceleration: PointDirection { y: -40 }
            velocity: AngleDirection { angle: 270; magnitude: flame.area / 2; angleVariation: 22; magnitudeVariation: magnitude / 4 }
        }
    }
}
