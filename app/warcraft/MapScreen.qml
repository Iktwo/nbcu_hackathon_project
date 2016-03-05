import QtQuick 2.0
import QtPositioning 5.5
import QtLocation 5.5
import QtQuick.Controls 1.4

Rectangle {
    id: root

    property variant defaultLocation: QtPositioning.coordinate(37.78, -122.41)

    property variant pois: [
        {lat: 37.78, lng: -122.42, name: "Test 1"},
        {lat: 37.72, lng: -122.41, name: "Test 2"},
        {lat: 37.74, lng: -122.40, name: "Test 3"}
    ]

    Plugin {
        id: _PluginMap

        name: "osm"
    }

    PositionSource {
        id: _PositionSource

        property variant lastSearchPosition: defaultLocation

        active: true
        updateInterval: 120000 // 2 mins
        onPositionChanged:  {
            var currentPosition = _PositionSource.position.coordinate
            _Map.center = currentPosition
            var distance = currentPosition.distanceTo(lastSearchPosition)
            if (distance > 500) {
                // 500m from last performed search
                lastSearchPosition = currentPosition
                searchModel.searchArea = QtPositioning.circle(currentPosition)
                searchModel.update()
            }
        }
    }

    ListModel {
        id: _ListModelPois

        Component.onCompleted: {
            for (var i = 0; i < root.pois.length; ++i) {
                append(root.pois[i])
            }
        }
    }

    Map {
        id: _Map

        anchors.fill: parent

        plugin: _PluginMap;
        center: defaultLocation
        zoomLevel: 13

        MapItemView {
            model: _ListModelPois

            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(model.lat, model.lng)

                anchorPoint.x: _Image.width * 0.5
                anchorPoint.y: _Image.height

                sourceItem: Column {
                    Image {
                        id: _Image
                        source: "images/orc_marker.png"
                        fillMode: Image.PreserveAspectFit
                        height: 64
                        width: 64
                    }

                    Text {
                        text: model.name; font.bold: true
                    }
                }
            }
        }
    }
}
