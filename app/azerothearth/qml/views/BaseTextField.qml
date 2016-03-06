import QtQuick 2.4
import QtQuick.Controls 1.4 as Controls

//Controls.TextField {
//    id: root
//    anchors.left: parent.left
//    anchors.right: parent.right

//    height: __theme.dp(120)
//    font.pixelSize: __theme.dp(72)

//    property bool error: false

//    Rectangle {
//        anchors.fill: parent
//        anchors.margins: border.width
//        color: "transparent"
//        border.width: 4
//        border.color: "#FF0000"
//        visible: root.error
//    }
//}

Rectangle {
    id: root

    property bool error: false
    property string realText: _textFieldDummy.text
    property string text: _label.text
    property string placeholderText: ""
    property alias echoMode: _textFieldDummy.echoMode

    property color themeColor: "#c7c9b4"

    color: "#000000"
    anchors.left: parent.left
    anchors.right: parent.right

    height: __theme.dp(120)

    border {
        width: __theme.dp(2)
        color: root.error ? "red" : "#604411"
        Behavior on color {
            ColorAnimation { duration: 100 }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            _textFieldDummy.forceActiveFocus()
        }
    }

    Image {
        anchors.fill: parent
        source: "../img/pattern-leather.jpg"
        fillMode: Image.Tile
        opacity: 0.2
    }

    Controls.TextField {
        id: _textFieldDummy
        anchors.fill: parent
        visible: false
        activeFocusOnPress: true
        inputMethodHints: Qt.ImhNoPredictiveText

        property string passwordText: {
            var t = "";
            for (var i = 0; i < text.length; i++) {
                t += "•";
            }
            return t;
        }
    }

    Rectangle {
        id: _rectangleCursor
        anchors.left: _label.right
        anchors.leftMargin: __theme.dp(4)
        width: __theme.dp(4)
        color: root.themeColor
        anchors.top: _label.top
        anchors.bottom: _label.bottom
        anchors.topMargin: __theme.dp(8)
        anchors.bottomMargin: anchors.topMargin
        opacity: 0.0
        visible: _textFieldDummy.focus

        SequentialAnimation {
            loops: Animation.Infinite
            running: _textFieldDummy.focus
            NumberAnimation {
                target: _rectangleCursor
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
            }
            PauseAnimation { duration: 100 }
            NumberAnimation {
                target: _rectangleCursor
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 200
            }
            PauseAnimation { duration: 100 }
        }
    }

    Label {
        id: _label
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: __theme.dp(20)
        anchors.topMargin: __theme.dp(10)
        anchors.bottomMargin: anchors.topMargin

        font.pixelSize: __theme.dp(root.height*0.40)

        verticalAlignment: Text.AlignVCenter

        color: root.themeColor
    }

    Label {
        id: _labelPlaceholder
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: __theme.dp(20)
        anchors.topMargin: __theme.dp(10)
        anchors.bottomMargin: anchors.topMargin

        font.pixelSize: __theme.dp(root.height*0.45)

        verticalAlignment: Text.AlignVCenter

        color: root.themeColor
        opacity: 0.75
        text: root.placeholderText
        visible: _stateGroup.state === "notFocused"
    }

    StateGroup {
        id: _stateGroup
        states: [
            State {
                name: "focused"
                when: _textFieldDummy.focus || _textFieldDummy.text != ""
                PropertyChanges {
                    target: _label
                    text: _textFieldDummy.echoMode === TextInput.Password ?
                              _textFieldDummy.passwordText
                            : _textFieldDummy.text
                }
            },
            State {
                name: "notFocused"
                when: !_textFieldDummy.focus && _textFieldDummy.text === ""
                PropertyChanges {
                    target: _label
                }
            }
        ]
    }
}
