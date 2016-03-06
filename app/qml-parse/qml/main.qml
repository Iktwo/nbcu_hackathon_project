import QtQuick 2.3
import QtQuick.Window 2.2

import QtQuick.Controls 1.4 as Controls
import QtPositioning 5.5

Window {
    visible: true
    width: 800
    height: 600

    QtObject {
        id: internal

        property string characterTypeOrc: "CHARACTERTYPE_ORC"
        property string characterTypeHuman: "CHARACTERTYPE_HUMAN"
    }

    Parse {
        id: _parse
    }


    PositionSource {
        id: _positionSource
        active: true
        onPositionChanged: {
            console.log("### POSITION")
            console.log(position.coordinate.latitude)
            console.log(position.coordinate.longitude)
            console.log("### END POSITION")
        }
    }

    Text {
        anchors.centerIn: parent
        color: "#00FEAA"
        font.pixelSize: 42
        text: _parse.isUserAuthenticated
        z: 1000000
    }

    Column {
        Controls.Button {
            text: "post POI object"
            onClicked: {
                var poi = {
                    "lat": 1337,
                    "long": 1337,
                    "name": "Golden Gate Bridge"
                }
                _parse.postPoi(poi);
            }
        }
        Controls.Button {
            text: "scrape POIs"
            onClicked: {
                _parse.foursquare_scrapeMonuments(function(monumentsResult) {
                    console.log(monumentsResult.response.venues.length);
                    for (var i = 0; i < monumentsResult.response.venues.length; i++) {
                        var venue = monumentsResult.response.venues[i];
                        var o = {
                            "id" : venue.id,
                            "name" : venue.name,
                            "location" : {
                                "__type" : "GeoPoint",
                                "latitude" : venue.location.lat,
                                "longitude" : venue.location.lng
                            }
                        }
                        _parse.postPoi(o);
                    }
                });
            }
        }
        Controls.Button {
            text: "scrape POIs for resources"
            onClicked: {
                _parse.foursquare_scrapeVenuesForResources(function(result) {
                    console.log(result.response.venues.length);

                    function randomIntFromInterval(min,max)
                    {
                        return Math.floor(Math.random()*(max-min+1)+min);
                    }

                    for (var i = 0; i < result.response.venues.length; i++) {
                        var venue = result.response.venues[i];


                        var arr = [];
                        for (var j = 0; j < randomIntFromInterval(3, 6); j++) {
                            arr.push("unclaimed");
                        }

                        var o = {
                            "id" : venue.id,
                            "name" : venue.name,
                            "location" : {
                                "__type" : "GeoPoint",
                                "latitude" : venue.location.lat,
                                "longitude" : venue.location.lng
                            },
                            "type" : "RESOURCETYPE_GOLD",
                            "allocations" : arr
                        }

                        _parse.postResourcePoi(o);
                    }
                });
            }
        }
        Controls.Button {
            text: "post User object"
            onClicked: {
                var userObject = _parse.buildUserObject("test"+Math.floor(Math.random()*1000), "test123");
                userObject.characterType = Math.floor(Math.random()*2) ?
                            internal.characterTypeOrc
                          : internal.characterTypeHuman;

                userObject.coordinate = {
                    latitude: "37.3839200",
                    longitude: "-122.0128440",
                }

                _parse.registerUser(userObject, function(result) {
                    console.log("registerUser result:");
                    console.log(JSON.stringify(result))
                });
            }
        }
        Controls.Button {
            text: "login User object"
            onClicked: {
                _parse.loginUser("test123", "test123", function(result) {
                    console.log("loginUser result:");
                    console.log(JSON.stringify(result))
                });
            }
        }
        Controls.Button {
            text: "get POI"
            onClicked: {
                _parse.getPois({ }, function(result) {
                    console.log(JSON.stringify(result, null, 2))
                });
            }
        }
        Controls.Button {
            text: "get resource POI"
            onClicked: {
                _parse.getResourcePois({ }, function(result) {
                    console.log(JSON.stringify(result, null, 2))
                });
            }
        }
    }
}

