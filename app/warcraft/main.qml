import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
    visible: true

    height: 1920 * 0.5
    width: 1080 * 0.5

    Component {
        id: _ComponentPickRaceScreen
        PickRaceScreen {
            onSelected: _StackView.push(_ComponentMapScreen)
        }
    }

    Component {
        id: _ComponentMapScreen
        MapScreen {

        }
    }


    StackView {
        id: _StackView

        anchors.fill: parent

        initialItem: LoginScreen {
            onLoggedIn: _StackView.push(_ComponentPickRaceScreen)
        }
    }
}
