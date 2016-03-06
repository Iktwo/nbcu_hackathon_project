import QtQuick 2.0
import QtPositioning 5.5
import QtLocation 5.5
import QtQuick.Controls 1.4

Rectangle {
    id: root

    property variant defaultLocation: QtPositioning.coordinate(37.78, -122.41)

    Plugin {
        id: _PluginMap

        name: "osm"
    }

    PositionSource {
        id: _PositionSource

        property variant lastPosition: defaultLocation

        active: true
        updateInterval: 15000
        onPositionChanged:  {
            var currentPosition = _PositionSource.position.coordinate
            _MapQuickItemCurrentPosition.coordinate = currentPosition
            // _Map.center = currentPosition
            var distance = currentPosition.distanceTo(lastPosition)
            if (distance > 500) {
                // 500m from last performed search
                lastPosition = currentPosition
                // searchModel.searchArea = QtPositioning.circle(currentPosition)
                // searchModel.update()
            }
        }
    }

    ListModel {
        id: _ListModelPois

        Component.onCompleted: {
            _parse.getPois({ }, function(result) {
                console.log(JSON.stringify(result))
                for (var i = 0; i < result.results.length; ++i) {
                    append(result.results[i])
                }
            });
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

            coordinate: _PositionSource.lastPosition

            anchorPoint.x: _RectangleCurrentPosition.width * 0.5
            anchorPoint.y: _RectangleCurrentPosition.height

            sourceItem: Rectangle {
                id: _RectangleCurrentPosition
                height: 100
                width: 100
                color: "#443498db"
            }
        }

        MapItemView {
            model: _ListModelPois

            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(model.lat, model.lng)

                anchorPoint.x: _Image.width * 0.5
                anchorPoint.y: _Image.height

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

        MouseArea {
            anchors.fill: parent
        }
    }
}
