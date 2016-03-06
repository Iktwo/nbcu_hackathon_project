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
            anchors.centerIn: parent
            group: "flame"

            emitRate: 120
            lifeSpan: 1200
            size: 20
            endSize: 10
            sizeVariation: 10
            acceleration: PointDirection { y: -40 }
            velocity: AngleDirection { angle: 270; magnitude: 20; angleVariation: 22; magnitudeVariation: 5 }
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
            size: 16
            endSize: 8
            sizeVariation: 8
            acceleration: PointDirection { y: -40 }
            velocity: AngleDirection { angle: 270; magnitude: 40; angleVariation: 22; magnitudeVariation: 5 }
        }

        TrailEmitter {
            id: smoke2
            width: root.width
            height: root.height/2 - 20
            group: "smoke"
            follow: "flame"

            emitRatePerParticle: 4
            lifeSpan: 2400
            size: 36
            endSize: 24
            sizeVariation: 12
            acceleration: PointDirection { y: -40 }
            velocity: AngleDirection { angle: 270; magnitude: 40; angleVariation: 22; magnitudeVariation: 5 }
        }
    }
}
