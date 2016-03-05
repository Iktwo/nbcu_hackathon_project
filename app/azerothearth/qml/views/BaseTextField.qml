import QtQuick 2.4
import QtQuick.Controls 1.4 as Controls

Controls.TextField {
    id: _textFieldUsername
    anchors.left: parent.left
    anchors.right: parent.right

    height: __theme.dp(120)
    font.pixelSize: __theme.dp(72)
}
