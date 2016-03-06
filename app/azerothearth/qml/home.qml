import QtQuick 2.3
import QtPositioning 5.5
import QtLocation 5.5

import "views" as Views
import "utils" as Utils

import AzerothEarth 1.0 as AZE

Rectangle {
    id: root

    Rectangle {
        // TODO: ND - Remove this redsquare
        width: 100
        height: 100
        color: "red"
        opacity: 0.25
        anchors.top: parent.top
        anchors.right: parent.right
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("## LOGOUT");
                _parse.logoutUser();
                _splashScreen.open();
            }
        }
        z: 100000000000
    }

    property bool isScreenPortrait: height >= width

    color: "#ffffff"
    width:  parent.width
    height: parent.height
    focus: true

    Parse {
        id: _parse

        onIsUserAuthenticatedChanged: {
            if (isUserAuthenticated) {
                _splashScreen.close();
            }
        }
    }

    property alias __positionSource: _PositionSource

    PositionSource {
        id: _PositionSource

        property var coordinate: null

        active: true
        updateInterval: 120000 // 2 mins

        onPositionChanged: {
            coordinate = position.coordinate;
        }
    }

    property alias __theme : _QtObject_Theme

    QtObject {
        id: _QtObject_Theme

        property alias fontFamily: font.name
        property int topMargin: 40

        property int headerHeight: 128
        property int headerRegionButtonFontSize : 28

        function shadeColor(c, percent) {
            var color = c.toString()
            var R = parseInt(color.substring(1,3),16);
            var G = parseInt(color.substring(3,5),16);
            var B = parseInt(color.substring(5,7),16);

            R = parseInt(R * (100 + percent) / 100);
            G = parseInt(G * (100 + percent) / 100);
            B = parseInt(B * (100 + percent) / 100);

            R = (R<255)?R:255;
            G = (G<255)?G:255;
            B = (B<255)?B:255;

            var RR = ((R.toString(16).length==1)?"0"+R.toString(16):R.toString(16));
            var GG = ((G.toString(16).length==1)?"0"+G.toString(16):G.toString(16));
            var BB = ((B.toString(16).length==1)?"0"+B.toString(16):B.toString(16));

            return "#"+RR+GG+BB;
        }

        function dp(value) {
            var factor = $*0.45
            if(Qt.platform.os === "osx")
                return value
            if(Qt.platform.os === "ios")
                return value
            return factor*value
        }
    }

    property bool isApple : Qt.platform.os === "ios"
                            || Qt.platform.os === "osx"
                            || Qt.platform.os === "mac"
    StateGroup {
        id: _StateGroup_Theme
        states: [
            State {
                name: "iphone5"
                extend: "ios"
                when: root.isApple && root.width === 640
                PropertyChanges {
                    target: __theme
                }
            },
            State {
                name: "iphone6"
                extend: "ios"
                when: root.isApple && root.width > 640
            },
            State {
                name: "ios"
                PropertyChanges {
                    target: __theme;
                    fontFamily: "Avenir Next"
                }
            },
            State {
                name: "android"
                when: Qt.platform.os === "android"
                PropertyChanges {
                    target: __theme
                }
            }
        ]
    }

    FontLoader { id: fontI }
    FontLoader { id: fontL }
    FontLoader { id: fontLI }
    FontLoader { id: font }

    Item {
        id: _Item_PageContainer
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        Behavior on scale { NumberAnimation { duration: 350; easing.type: Easing.OutCubic} }

        z: 1
    }

    Views.SplashScreen {
        id: _splashScreen
        anchors.fill: parent

        onClosing: {
            close();
        }

        z: 2
    }

    property alias __dialog: _dialog
    Views.Dialog {
        id: _dialog
        z: 10
    }
}
