import QtQuick 2.0
import QtPositioning 5.5
import QtLocation 5.5
import QtQuick.Controls 1.4
import "../"

Rectangle {
    id: root

    property variant defaultLocation: QtPositioning.coordinate(37.78, -122.41)
    property variant lastPosition: defaultLocation

    ListModel {
        id: _ListModelNearResources
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
                _ListModelNearResources.append(model)
            }
        }
    }

    onDefaultLocationChanged: updateClosest()
    onLastPositionChanged: updateClosest()

    Plugin {
        id: _PluginMap

        name: "osm"
    }

    PositionSource {
        id: _PositionSource

        active: true
        updateInterval: 5000
        onPositionChanged:  {
            var currentPosition = _PositionSource.position.coordinate
            _MapQuickItemCurrentPosition.coordinate = currentPosition
            root.lastPosition = currentPosition
        }
    }

    ListModel {
        id: _ListModelPois

        Component.onCompleted: {
            _parse.getPois({ }, function(result) {
                for (var i = 0; i < result.results.length; ++i) {
                    append(result.results[i])
                }

                root.updateClosest()
            });
        }
    }

    ListModel {
        id: _ListModelResources

        Component.onCompleted: {
            _parse.getResourcePois({ }, function(result) {
                // console.log(JSON.stringify(result, null, 2))
                for (var i = 0; i < result.results.length; ++i) {
                    append(result.results[i])
                }

                root.updateClosest()
            })
        }
    }

    Map {
        id: _Map

        anchors.fill: parent

        plugin: _PluginMap;
        center: defaultLocation
        zoomLevel: 13

        MapQuickItem {
            id: _MapQuickItemCurrentPosition

            coordinate: root.lastPosition

            anchorPoint.x: _ImageCurrentPosition.width * 0.5
            anchorPoint.y: _ImageCurrentPosition.height * 0.5

            sourceItem: Image {
                id: _ImageCurrentPosition
                height: 100
                width: 100
                source: "../img/location-orc.png"
            }
        }

        MapItemView {
            model: _ListModelPois

            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(model.location.latitude, model.location.longitude)

                anchorPoint.x: _Image.width * 0.5
                anchorPoint.y: _Image.height * 0.5

                sourceItem: Column {
                    Image {
                        id: _Image

                        anchors.horizontalCenter: parent.horizontalCenter

                        source: "../img/marker-orc.png"
                        fillMode: Image.PreserveAspectFit
                        height: __theme.dp(Math.min(12 * _Map.zoomLevel, 128))
                        width: __theme.dp(Math.min(12 * _Map.zoomLevel, 128))
                    }

                    Label {
                        text: model.name

                        opacity: _Map.zoomLevel >= 15
                        font.pixelSize: __theme.dp(36)

                        color: "#ffffff"
                        styleColor: "#000000"
                        style: Text.Outline
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        width: _Image.width * 2
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

                    height: __theme.dp(Math.min(9 * _Map.zoomLevel, 97))
                    width: __theme.dp(Math.min(9 * _Map.zoomLevel, 97))

                    Smoke {
                        id: _Smoke

                        anchors.fill: parent

                        opacity: 0.8
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
        }
    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Button {
            opacity: enabled ? 1 : 0.6
            enabled: _ListModelNearResources.count > 0
            width: parent.width
            height: __theme.dp(60)
            text: qsTr("Grab gold")
        }
    }
}
