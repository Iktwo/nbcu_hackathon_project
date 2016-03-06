import QtQuick 2.0
import QtGraphicalEffects 1.0 as QGE
import QtPositioning 5.5
import QtLocation 5.5
import QtQuick.Controls 1.4 as QC
import QtQuick.Controls.Styles 1.4
import AzerothEarth 1.0 as AZE
import "../"
import "."

Rectangle {
    id: root

    property variant defaultLocation: QtPositioning.coordinate(37.78, -122.41)
    property variant lastPosition: defaultLocation

    property var allocations: ({})

    property var onFire: []

    ListModel {
        id: _ListModelClaimed
    }

    ListModel {
        id: _ListModelNearResources
    }

    function refresh() {
        _parse.getPois({ }, function(result) {
            _ListModelPois.clear()
            for (var i = 0; i < result.results.length; ++i) {
                _ListModelPois.append(result.results[i])
            }

            root.updateClosest()

            onFire = []

            var x = []

            for (var j = 0; j < 4; ++j) {
                x.push(Math.floor(Math.random() * (_ListModelPois.count - 1)))
            }

            onFire = x
        });

        _parse.getResourcePois({ }, function(result) {
            allocations = {}
            _ListModelResources.clear()
            for (var i = 0; i < result.results.length; ++i) {
                var model = result.results[i]
                allocations[model.objectId] = model.allocations

                var canAllocate = true
                var available = 0

                for (var j = 0; j < model.allocations.length; ++j) {
                    if (model.allocations[j] === _parse.userObject.objectId)
                        canAllocate = false
                    else if (model.allocations[j] === "unclaimed")
                        available += 1
                }

                if (canAllocate && available > 0)
                    _ListModelResources.append(model)
            }

            root.updateClosest()
        })
    }

    function updateClosest() {
        _ListModelNearResources.clear()

        var closest = 999

        for (var i = 0; i < _ListModelResources.count; ++i) {

            var model = _ListModelResources.get(i)

            var distance = lastPosition.distanceTo(QtPositioning.coordinate(model.location.latitude, model.location.longitude))

            if (distance < closest)
                closest = distance

            if (distance <= 50) {
                var claimed = false

                for (var j = 0; j < _ListModelClaimed.count; ++j) {
                    if (model.objectId === _ListModelClaimed.get(j).objectId) {
                        claimed = true
                        break
                    }
                }

                if (!claimed)
                    _ListModelNearResources.append(model)
            }
        }

        //        for (var i = 0; i < _ListModelResources.count; ++i) {
        //            var model = _ListModelResources.get(i)
        //            //            console.log("Checking resource: ", JSON.stringify(model))

        //            console.log(defaultLocation.distanceTo(QtPositioning.coordinate(model.location.latitude, model.location.longitude)))
        //        }
    }

    color: "#000000"

    Component.onCompleted: refresh()

    onDefaultLocationChanged: updateClosest()
    onLastPositionChanged: updateClosest()

    Plugin {
        id: _PluginMap

        name: "mapbox"

        PluginParameter {
            name:  "mapbox.access_token"
            value: "pk.eyJ1IjoiaWt0d28iLCJhIjoiY2lsZmpxYzV4MXNqYXZhbWM5Y3QyajZldyJ9.C7kwcU6xIzKEB_vvkFT2wg"
        }

        PluginParameter {
            name:  "mapbox.map_id"
            value: "iktwo.7adw8p9p"
        }
    }

    PositionSource {
        id: _PositionSource

        active: true
        updateInterval: 1000
        onPositionChanged:  {
            var currentPosition = _PositionSource.position.coordinate
            _MapQuickItemCurrentPosition.coordinate = currentPosition
            root.lastPosition = currentPosition
        }
    }

    ListModel {
        id: _ListModelPois
    }

    ListModel {
        id: _ListModelResources
    }

    Map {
        id: _Map

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: _ColumnContainer.top
        }

        plugin: _PluginMap;
        center: defaultLocation
        zoomLevel: 13

        MapQuickItem {
            id: _MapQuickItemCurrentPosition

            coordinate: root.lastPosition

            anchorPoint.x: _ImageCurrentPosition.width * 0.5
            anchorPoint.y: _ImageCurrentPosition.height * 0.5

            sourceItem: Item {
                width: _ImageCurrentPosition.width
                height: _ImageCurrentPosition.height

                Rectangle {
                    id: _rectangleCurrentLocation2
                    width: parent.width
                    height: width
                    anchors.centerIn: parent
                    opacity: 0.25

                    radius: width / 2

                    color: _rectangleCurrentLocation.color
                }
                Rectangle {
                    id: _rectangleCurrentLocation
                    width: parent.width
                    height: width
                    anchors.centerIn: parent

                    radius: width / 2

                    color: _parse.userObject.characterType === "CHARACTERTYPE_ORC" ?
                               "#ef492f"
                             : "#387ee5"

                    SequentialAnimation {
                        running: true
                        loops: Animation.Infinite

                        ParallelAnimation {
                            NumberAnimation {
                                target: _rectangleCurrentLocation
                                property: "width"
                                from: _rectangleCurrentLocation.parent.width/2
                                to: 2*_rectangleCurrentLocation.width

                                duration: 3000
                                easing.type: Easing.OutCubic
                            }
                            NumberAnimation {
                                target: _rectangleCurrentLocation
                                property: "opacity"
                                from: 0.70
                                to: 0.0

                                duration: 2000
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }

                Image {
                    id: _ImageCurrentPosition
                    height: __theme.dp(Math.min(8 * _Map.zoomLevel, 90))
                    width: __theme.dp(Math.min(8 * _Map.zoomLevel, 90))
                    source: _parse.userObject.characterType === "CHARACTERTYPE_ORC" ? "../img/marker-orc.png" : "../img/marker-human.png"
                }
            }
        }

        MapItemView {
            model: _ListModelPois

            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(model.location.latitude, model.location.longitude)

                anchorPoint.x: _ItemBase.width * 0.5
                anchorPoint.y: _ItemBase.height * 0.5

                sourceItem: Column {
                    Item {
                        id: _ItemBase

                        property int type: Math.round(Math.random() * (1))
                        property bool onFire: root.onFire.indexOf(index) != -1

                        anchors.horizontalCenter: parent.horizontalCenter

                        height: __theme.dp(Math.min(35 + (8 * _Map.zoomLevel), 128))
                        width: __theme.dp(Math.min(35 + (8 * _Map.zoomLevel), 128))

                        Loader {
                            anchors.fill: parent

                            sourceComponent: parent.onFire ? _ComponentA : _ComponentB
                            asynchronous: true
                            z: parent.onFire ? 3 : 1
                        }

                        Component {
                            id: _ComponentA

                            Fire {
                                height: parent.height
                                width: parent.width
                                y: -height * 0.4

                                opacity: 0.4
                            }
                        }

                        Component {
                            id: _ComponentB

                            Smoke {
                                anchors.fill: parent

                                smokeColor: parent.type === 1 ? colors.orc : colors.human
                                opacity: 0.8
                            }
                        }

                        Image {
                            id: _Image

                            anchors.fill: parent
                            anchors.margins: parent.height * 0.05

                            source: parent.type === 1 ? "../img/marker-orc.png" : "../img/marker-human.png"
                            fillMode: Image.PreserveAspectFit
                            z: 2
                        }
                    }


                    Label {
                        text: model.name

                        opacity: _Map.zoomLevel >= 15
                        font.pixelSize: __theme.dp(Math.min(14 + (220 / _Map.zoomLevel), 36))

                        color: "#ffffff"
                        styleColor: "#000000"
                        style: Text.Outline
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        width: _ItemBase.width * 2.5
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignHCenter

                        Behavior on opacity { NumberAnimation { } }
                    }
                }
            }
        }

        MapItemView {
            model: _ListModelResources

            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(model.location.latitude, model.location.longitude)

                anchorPoint.x: _ItemContainer.width * 0.5
                anchorPoint.y: _ItemContainer.height * 0.5

                sourceItem: Item {
                    id: _ItemContainer

                    height: __theme.dp(Math.min(15 + (4 * _Map.zoomLevel), 97))
                    width: __theme.dp(Math.min(15 + (4 * _Map.zoomLevel), 97))

                    Smoke {
                        id: _Smoke

                        anchors.fill: parent

                        opacity: 0.8
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: false
                        onClicked: {
                            console.log(Object.keys(root.allocations), root.allocations[model.objectId])
                            console.log(JSON.stringify(model))
                            mouse.accepted = false
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
        }

        MouseArea {
            anchors {
                right: parent.right;
                bottom: parent.bottom;
            }


            onClicked: {
                if (_Map.zoomLevel < 18)
                    _Map.zoomLevel = 18

                _Map.center = lastPosition
            }
            opacity: pressed ? 1.0 : 0.65
            width: __theme.dp(110)
            height: __theme.dp(110)

            Image {
                anchors.fill: parent
                anchors.margins: __theme.dp(20)
                fillMode: Image.PreserveAspectFit
                source: "../img/icon-gps.png"

                layer.enabled: true
                layer.effect: QGE.ColorOverlay {
                    color: "#FFFFFF"
                }
            }

            z: 9
        }
    }

    Rectangle {
        id: _RectangleStats

        anchors.fill: _ColumnContainer

        color: "#000000"
    }

    Column {
        id: _ColumnContainer

        anchors {
            left: parent.left; leftMargin: __theme.dp(10)
            right: parent.right; rightMargin: __theme.dp(10)
            bottom: parent.bottom
        }

        Item {
            height: __theme.dp(10)
            width: 1
        }

        BaseButton {
            opacity: enabled ? 1 : 0.45
            enabled: _ListModelNearResources.count > 0
            width: parent.width
            height: __theme.dp(140)
            text: qsTr("Grab gold")
            onClicked: {
                var model = _ListModelNearResources.get(0)
                model.allocations = root.allocations[model.objectId]
                _parse.claimResource(model, function() {
                    _parse.incrementResourceTypeGoldCount(function() {
                        _ListModelClaimed.append(model)
                        _ListModelNearResources.clear()
                        _parse.refreshUserInformation()
                        root.refresh()
                    })
                })
            }
        }

        Item {
            height: __theme.dp(20)
            width: 1
        }

        Row {
            anchors {
                left: parent.left
                right: parent.right
            }

            height: Math.max(_LabelStats.height, _ImageType.height)

            Item {
                height: 1
                width: __theme.dp(4)
            }

            Image {
                id: _ImageType

                anchors.verticalCenter: parent.verticalCenter

                height: __theme.dp(80)
                width: __theme.dp(80)
                source: _parse.userObject.characterType === "CHARACTERTYPE_ORC" ? "../img/marker-orc.png" : "../img/marker-human.png"
            }

            Item {
                height: 1
                width: __theme.dp(4)
            }

            Smoke {
                anchors {
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: __theme.dp(18)
                }

                height: __theme.dp(40)
                width: __theme.dp(40)
            }

            Item {
                height: 1
                width: __theme.dp(4)
            }

            Label {
                id: _LabelStats

                anchors.verticalCenter: parent.verticalCenter

                color: "#ffffff"
                font.pixelSize: __theme.dp(60)
                text: _parse.userObject.resourceTypeGoldCount
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: "ElideRight"

                Component.onCompleted: console.log("Userdata:", JSON.stringify(_parse.userObject))
            }

            Item {
                height: 1
                width: parent.parent.width - x - _ImageShare.width - __theme.dp(10)
            }

            Item {
                id: _ImageShare

                anchors.verticalCenter: parent.verticalCenter

                width: parent.height
                height: parent.height

                Image {
                    anchors.fill: parent
                    anchors.margins: height * 0.05
                    source: "../img/share.png"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: _RectangleDialog.open()
                }
            }

        }

        Item {
            height: __theme.dp(10)
            width: 1
        }
    }

    //    Button {
    //        anchors.centerIn: parent

    //        width: __theme.dp(140)
    //        height: __theme.dp(140)
    //        onClicked: refresh()
    //    }

    Rectangle {
        id: _RectangleDialog

        function open() {
            opacity = 1
            enabled = 1
        }

        function close() {
            opacity = 0
            enabled = 0
        }

        anchors.fill: parent

        opacity: 0
        enabled: false
        color: "#88000000"

        MouseArea {
            anchors.fill: parent
            onClicked: _RectangleDialog.close()
        }

        Behavior on opacity { NumberAnimation { } }

        BaseButton {
            anchors {
                top: _RectangleMainStats.bottom; topMargin: __theme.dp(40)
                horizontalCenter: _RectangleMainStats.horizontalCenter
            }

            color: "#AA000000"
            width: _RectangleMainStats.width * 0.5
            text: "Share"
            onClicked: {
                _RectangleDialog.grabToImage(function(result) {
                    result.saveToFile("/sdcard/test.png")
                    AZE.ImageShare.shareImage()
                })
            }
        }

        Rectangle {
            id: _RectangleMainStats

            anchors {
                left: parent.left; leftMargin: parent.width * 0.05
                right: parent.right; rightMargin: parent.width * 0.05
                top: parent.top; topMargin: __theme.dp(200)
            }

            color: "#000000"

            gradient: Gradient {
                GradientStop {
                    position: 0.25
                    color: "#664f10"
                }
                GradientStop {
                    position: 1.0
                    color: "#000000"
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "#000000"
                opacity: 0.65

                border.width: 2
                border.color: "#604411"
            }

            Image {
                anchors.fill: parent
                fillMode: Image.Tile
                source: "../img/pattern-leather.jpg"
                opacity: 0.25
            }

            height: Math.max(_ColumnStatsContent.height + __theme.dp(100), __theme.dp(400))

            Rectangle {
                anchors.fill: parent

                color: "#00000000"

                border {
                    color: "#f1c40f"
                    width: __theme.dp(8)
                }
            }

            Column {
                id: _ColumnStatsContent

                anchors {
                    left: parent.left
                    right: parent.right
                }

                Item {
                    height: __theme.dp(10)
                    width: 1
                }

                Image {
                    width: parent.width
                    height: width / 2
                    fillMode: Image.PreserveAspectFit
                    source: "../img/main-logo-w-slogan.png"
                }

                Item {
                    height: __theme.dp(10)
                    width: 1
                }

                Row {
                    anchors {
                        left: parent.left; leftMargin: __theme.dp(16)
                        right: parent.right; rightMargin: __theme.dp(16)
                    }

                    height: _ImageType2.height

                    Item {
                        height: 1
                        width: __theme.dp(4)
                    }

                    Image {
                        id: _ImageType2

                        anchors.verticalCenter: parent.verticalCenter

                        height: __theme.dp(200)
                        width: __theme.dp(200)
                        source: _parse.userObject.characterType === "CHARACTERTYPE_ORC" ? "../img/marker-orc.png" : "../img/marker-human.png"
                    }

                    Column {
                        anchors.verticalCenter: _ImageType2.verticalCenter
                        width: parent.width - x
                        //height: _ImageType2.height

                        Row {
                            width: parent.width

                            Item {
                                height: 1
                                width: __theme.dp(16)
                            }

                            Label {
                                width: parent.width

                                color: "#ffffff"
                                font.pixelSize: __theme.dp(60)
                                text: _parse.userObject.username
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: "ElideRight"
                            }
                        }

                        Row {
                            width: parent.width

                            Item {
                                height: 1
                                width: __theme.dp(4)
                            }

                            Smoke {
                                id: _SmokeT

                                anchors {
                                    verticalCenter: parent.verticalCenter
                                    verticalCenterOffset: __theme.dp(36)
                                }

                                height: __theme.dp(80)
                                width: __theme.dp(80)
                            }

                            Item {
                                height: 1
                                width: __theme.dp(4)
                            }

                            Label {
                                id: _LabelStats2

                                anchors.verticalCenter: parent.verticalCenter

                                color: "#ffffff"
                                font.pixelSize: __theme.dp(60)
                                text: _parse.userObject.resourceTypeGoldCount + " GOLD"
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: "ElideRight"
                            }

                            Item {
                                height: 1
                                width: __theme.dp(10)
                            }
                        }
                    }
                }
            }
        }
    }
}
