import QtQuick 2.4

import Qt.labs.settings 1.0

Item {
    id: root

    readonly property bool isUserAuthenticated: internal.sessionToken !== ""

    property var userObject: null
    property var user2Object: ({})


    property string version: "1"
    property string urlBase: "https://api.parse.com/"+version+"/"
    property string urlClasses: urlBase + "classes/"
    property string urlUsers: urlBase + "users/"
    property string urlUserLogin: urlBase + "login/"

    property string url2Base: "http://nbcu.mybluemix.net/api/"
    property string url2UserCreate: url2Base + "join"
    property string url2PlayerUpdate: url2Base + "player/update"
    property string url2UserLogin: url2Base + "login"

    property string classNamePoi: "poi"
    property string classNameResource: "resource"
    property string classNameSoldier: "soldier"
    property string classNameBattle: "battle"

    property string appId: "UPJFfR8GO7kXYFPicuKK0mdakfcL73vU4PwzsiV9"
    property string apiKey: "lUbm8jUTe7efq4dbgzV88bMoZ1G2kE1TPDB6V0Sk"

    property string errorStringUsernameTaken: "USERNAME_ALREADY_TAKEN"
    property string errorStringUsernameNotDefined: "USERNAME_NOT_DEFINED"
    property string errorStringPasswordNotDefined: "PASSWORD_NOT_DEFINED"
    property string errorStringUsernameTooShort: "USERNAME_TOO_SHORT"
    property string errorStringPasswordTooShort: "PASSWORD_TOO_SHORT"
    property string errorStringPasswordIncorrect: "PASSWORD_INCORRECT"
    property string errorStringUserHasAlreadyClaimedResource: "USER_HAS_ALREADY_CLAIMED_RESOURCE"
    property string errorStringNotEnoughGold: "NOT_ENOUGH_GOLD"

    property int goldCostPerSoldier: 5

    function monuments_from_server(callback){
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://nbcu.mybluemix.net/api/landmarks/getnearby");
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                var result = JSON.parse(xhr.responseText);
                if (callback) {
                    callback(result);
                }
            }
        }
    }

    function foursquare_scrapeMonuments(callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", foursquare.urlVenues_Monuments, true);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                var result = JSON.parse(xhr.responseText);
                if (callback) {
                    callback(result);
                }
            }
        }

        xhr.send();
    }

    function saveUserWithClass(callback){
        internal.post("http://nbcu.mybluemix.net/api/player/update/", characterShortName, function(result, error){
            var errorString = "";
            if (error) {
                if (result.code === 202) {
                    errorString = root.errorStringUsernameTaken;
                }
                callback({
                             status: 0,
                             result: result,
                             errorString: errorString
                         });
            } else {
                try {
                    internal.sessionToken = result.sessionToken;
                } catch (ex) {
                    console.warn("user signed in successfully but no session token not found");
                }
                callback({
                             status: 1,
                             result: result,
                             errorString: errorString
                         });
            }
        });
    }

    function foursquare_scrapeVenuesForResources(callback) {
        var xhr = new XMLHttpRequest();
        console.log("scrapeVenuesForResources url:", foursquare.urlVenuesShopsServices)
        xhr.open("GET", foursquare.urlVenuesShopsServices, true);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                var result = JSON.parse(xhr.responseText);
                if (callback) {
                    callback(result);
                }
            }
        }

        xhr.send();
    }

    Settings {
        id: _settings

        property string sessionToken

        Component.onCompleted: {
            console.log("QSettings completed:", sessionToken);
            if (sessionToken) {
                internal.validateSession(sessionToken);
            }
        }
    }

    Connections {
        target: internal
        onSessionTokenChanged: {
            _settings.sessionToken = internal.sessionToken;
        }
    }

    QtObject {
        id: foursquare

        property string clientId: "ZTNRJYVFMKVOKLNIMBSRN4CXRJJDD141CRJCEYZBBTV13SCL"
        property string clientSecret: "TEQGO515PTXVXHRIFNAKGWFYSLHRYPKZIX5VGTPSLJ5KTNWC"

        property string urlSuffix: "&client_id=" + clientId + "&client_secret=" + clientSecret + "&v=20160305"
        property string urlVenues_Monuments: "https://api.foursquare.com/v2/venues/search/?limit=50&ll=37.773972,-122.431297&categoryId=4bf58dd8d48988d12d941735" + urlSuffix
        property string urlVenuesShopsServices: "https://api.foursquare.com/v2/venues/search/?limit=50&ll=37.773972,-122.431297&categoryId=4d4b7105d754a06378d81259" + urlSuffix
    }

    QtObject {
        id: internal

        property string sessionToken: ""

        function __buildXhr(httpType, url, obj, callback) {
            var xhr = new XMLHttpRequest();

            if (httpType === "GET" || httpType === "PUT") {
                var getUrl = url + "/?";
                var keys = Object.keys(obj);
                for (var i = 0; i < keys.length; i++) {
                    if (i > 0) {
                        getUrl += "&"
                    }
                    getUrl += keys[i] + "=" + encodeURIComponent(obj[keys[i]]);
                }
                console.log("getUrl=", getUrl)
                xhr.open(httpType, getUrl, true);
            } else {
                xhr.open(httpType, url, true);
            }

            xhr.setRequestHeader("X-Parse-Application-Id", root.appId);
            xhr.setRequestHeader("X-Parse-REST-API-Key", root.apiKey);
            if (internal.sessionToken) {
                xhr.setRequestHeader("X-Parse-Session-Token", internal.sessionToken);
            }
            xhr.setRequestHeader("Content-Type", "application/json");

            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    console.log("### START RESPONSE");
                    console.log(xhr.responseText);
                    console.log("### END RESPONSE");
                    var result = JSON.parse(xhr.responseText);
                    if (callback) {
                        callback(result);
                    } else {
                        console.warn("callback not found");
                    }
                }
            }

            var data = JSON.stringify(obj);
            console.log(url, data);

            if (httpType === "GET") {
                xhr.send();
            } else {
                xhr.send(data);
            }
        }

        function del(url, obj, callback) {
            __buildXhr("DELETE", url, obj, callback);
        }

        function put(url, obj, callback) {
            __buildXhr("PUT", url, obj, callback);
        }

        function post(url, obj, callback) {
            __buildXhr("POST", url, obj, callback);
        }

        function get(url, obj, callback) {
            __buildXhr("GET", url, obj, callback);
        }

        function postClass(className, obj, callback) {
            post(urlClasses + className, obj, callback);
        }

        function getClass(className, obj, callback) {

            var addition = obj.objectId ? "/" + obj.objectId : "";

            get(urlClasses + className + addition, obj, callback);

            console.log(urlClasses + className);
        }

        function putClass(className, obj, callback) {
            var o = JSON.parse(JSON.stringify(obj));
            delete o.objectId;
            put(urlClasses + className + "/" + obj.objectId, o, callback);
        }

        function deleteClass(className, obj, callback) {
            del(urlClasses + className + "/" + obj.objectId, obj, callback);
        }

        function validateSession(sessionToken) {
            var xhr = new XMLHttpRequest();

            xhr.open("GET", "https://api.parse.com/1/users/me", true);
            xhr.setRequestHeader("X-Parse-Application-Id", root.appId);
            xhr.setRequestHeader("X-Parse-REST-API-Key", root.apiKey);
            xhr.setRequestHeader("X-Parse-Session-Token", sessionToken);
            xhr.setRequestHeader("Content-Type", "application/json");

            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {

                    console.log("RESULT", "https://api.parse.com/1/users/me", xhr.responseText);
                    var result = JSON.parse(xhr.responseText);
                    var error = true;
                    if (result.objectId) {
                        error = false;
                    }

                    if (!error) {
                        internal.sessionToken = sessionToken;
                        root.userObject = result;
                    }
                }
            }

            console.log("GET", "https://api.parse.com/1/users/me");
            xhr.send();
        }

        function logout() {
            var xhr = new XMLHttpRequest();

            xhr.open("GET", "https://api.parse.com/1/users/me", true);
            xhr.setRequestHeader("X-Parse-Application-Id", root.appId);
            xhr.setRequestHeader("X-Parse-REST-API-Key", root.apiKey);
            xhr.setRequestHeader("X-Parse-Session-Token", internal.sessionToken);
            xhr.setRequestHeader("Content-Type", "application/json");

            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    var result = JSON.parse(xhr.responseText);

                    internal.sessionToken = "";
                }
            }

            xhr.send();
        }

    }

    function registerUser(userObject, callback) {
        if (!userObject.username) {
            callback({ status: 0, errorString: root.errorStringUsernameNotDefined });
            return;
        }

        if (!userObject.password) {
            callback({ status: 0, errorString: root.errorStringPasswordNotDefined });
            return;
        }

        if (userObject.username.length < 4) {
            callback({ status: 0, errorString: root.errorStringUsernameTooShort });
            return;
        }

        if (userObject.password.length < 4) {
            callback({ status: 0, errorString: root.errorStringPasswordTooShort });
            return;
        }
        var characterShortName = userObject.characterType === "CHARACTERTYPE_ORC" ? "orc" : "human"

        console.log("attempting to register user:");
        console.log(JSON.stringify(userObject, null, 2));
        user2Object.raceName = characterShortName;
        user2Object.username = userObject.username.toLowerCase();
        user2Object.password = userObject.password;

        userObject.username = userObject.username.toLowerCase();
        // Give the user 1 resourceTypeGold
        userObject.resourceTypeGoldCount = 1;

        internal.post(url2UserCreate, user2Object, function (res, err){
            var errorString = "";
            if (error) {
                if (result.code === 202) {
                    errorString = root.errorStringUsernameTaken;
                }
                callback({
                             status: 0,
                             result: result,
                             errorString: errorString
                         });
            } else {
                try {
                    internal.sessionToken = result.sessionToken;
                } catch (ex) {
                    console.warn("user signed in successfully but no session token not found");
                }
                callback({
                             status: 1,
                             result: result,
                             errorString: errorString
                         });
            }
        });

        internal.post(urlUsers, userObject, function(result, error) {
            var errorString = "";
            if (error) {
                if (result.code == 202) {
                    errorString = root.errorStringUsernameTaken;
                }
                callback({
                             status: 0,
                             result: result,
                             errorString: errorString
                         });
            } else {
                try {
                    internal.sessionToken = result.sessionToken;
                } catch (ex) {
                    console.warn("user signed in successfully but no session token not found");
                }
                callback({
                             status: 1,
                             result: result,
                             errorString: errorString
                         });
            }
        });
    }

    function loginUser(username, password, callback) {
        if (!username) {
            callback({ status: 0, errorString: "USERNAME_NOT_DEFINED" });
            return;
        }

        if (!password) {
            callback({ status: 0, errorString: "PASSWORD_NOT_DEFINED" });
            return;
        }

        var o = {
            "username": username,
            "password": password
        }

        o.username = o.username.toLowerCase();

        internal.get(urlUserLogin, o, function(result, error) {
            var errorString = "";
            if (result.code == 201 || result.code == 101) {
                error = true;
            }
            if (error) {
                if (result.code == 201 || result.code == 101) {
                    errorString = root.errorStringPasswordIncorrect;
                }
                callback({
                             status: 0,
                             result: result,
                             errorString: errorString
                         });
            } else {
                try {
                    internal.sessionToken = result.sessionToken;
                } catch (ex) {
                    console.warn("user logged in successfully but no session token not found");
                }

                root.userObject = result;

                callback({
                             status: 1,
                             result: result,
                             errorString: errorString
                         });
            }
        });
    }

    function logoutUser() {
        internal.logout();
    }

    function buildUserObject(username, password) {
        return { username: username, password: password };
    }

    // Get a list of POIs
    function getPois(obj, callback) {
        internal.getClass(classNamePoi, obj || { }, callback);
    }

    // Post a POI
    function postPoi(poi) {
        internal.postClass(classNamePoi, poi, function(result, error) {
            console.log("result.objectId", result.objectId);
        });
    }

    // Post a resource POI
    function postResourcePoi(poi) {
        internal.postClass(classNameResource, poi, function(result, error) {
            console.log("result.objectId", result.objectId);
        });
    }

    // Get a list of Resource POIs
    function getResourcePois(obj, callback) {
        var o = obj || { }
        o.available = true;
        internal.getClass(classNameResource, o, callback);
    }

    function getClosestBase(latLongObject, callback) {

        if (!latLongObject) {
            console.warn("provide latLongObject");
            return;
        }

        var o = {
            "where" : '{
                "available" : true,
                "location": {
                    "$nearSphere": {
                        "__type": "GeoPoint",
                        "latitude": ' + latLongObject.latitude + ',
                        "longitude": ' + latLongObject.longitude + '
                    },
                    "$maxDistanceInMiles": 1
                }
            }'
        }

        internal.getClass(classNamePoi, o, callback);
    }

    function claimPoi(poiObject, numberOfSoldiers, callback) {
        if (!poiObject) {
            console.warn("no resourceObject given");
            return;
        }

        if (!userObject) {
            console.warn("user is not logged in");
            return;
        }

        if (root.userObject.resourceTypeGoldCount < numberOfSoldiers*root.goldCostPerSoldier) {
            console.warn("not enough gold to purchase");
            callback({status: 0, errorString: root.errorStringNotEnoughGold });
            return;
        }

        deploySoldiers(poiObject, numberOfSoldiers);

        if (!poiObject.available) {
            // []
            // Start Battle if necessary
            // Execute battle here
        }
    }

    function findClosestResource(latLongObject, callback) {
        if (!latLongObject) {
            console.warn("provide latLongObject");
            return;
        }

        var o = {
            "where" : '{
                "available" : true,
                "location": {
                    "$nearSphere": {
                        "__type": "GeoPoint",
                        "latitude": ' + latLongObject.latitude + ',
                        "longitude": ' + latLongObject.longitude + '
                    },
                    "$maxDistanceInMiles": 1
                }
            }'
        }

        internal.getClass(classNameResource, o, callback);
    }

    function claimResource(resourceObject, callback) {
        if (!resourceObject) {
            console.warn("no resourceObject given");
            return;
        }

        if (!userObject) {
            console.warn("user is not logged in");
            return;
        }

        if (!resourceObject.allocations) {
            console.warn("resource has no allocations");
            return;
        }

        var allocations = resourceObject.allocations;

        var allocateIndex = -1;
        for (var i = 0; i < allocations.length; i++) {
            if (allocations[i] === root.userObject.objectId) {
                console.warn("this user has already claimed this resource");
                callback({
                             status: 0,
                             result: null,
                             errorString: root.errorStringUserHasAlreadyClaimedResource
                         });
                return;
            } else if (allocations[i] === "unclaimed") {
                allocateIndex = i;
                break;
            }
        }

        if (allocateIndex === -1) {
            console.warn("no allocations remaining");
            return;
        }

        allocations[allocateIndex] = root.userObject.objectId;

        var unavailable = allocateIndex === allocations.length - 1;

        internal.putClass(classNameResource, {
                              objectId: resourceObject.objectId,
                              allocations: allocations,
                              available: !unavailable
                          }, callback);
    }

    function incrementResourceTypeGoldCount(callback) {
        if (!root.userObject) {
            console.warn("must be logged in");
            return;
        }

        var o = {
            resourceTypeGoldCount: {"__op": "Increment", "amount": 1 }
        }

        internal.put(urlUsers + "/" + root.userObject.objectId, o, callback);
    }

    function decrementResourceTypeGoldCount(callback) {
        if (!root.userObject) {
            console.warn("must be logged in");
            return;
        }

        var o = {
            resourceTypeGoldCount: {"__op": "Increment", "amount": -1 }
        }

        internal.put(urlUsers + "/" + root.userObject.objectId, o, callback);
    }

    function refreshUserInformation() {
        internal.validateSession(internal.sessionToken);
    }

    function deploySoldiers(poiObject, numberOfSoldiers) {
        var soldier = {
            userObjectId: root.userObject.objectId,
            poiObjectId: poiObject.objectId,
            characterType: root.userObject.characterType,
            available: true,
            count: numberOfSoldiers
        }
        internal.postClass(classNameSoldier, soldier, function(result) {
            console.log("RESPONSE", "deploySoldiers");
            console.log(JSON.stringify(result));
        });
    }

    function getSoldierCountForPoi(poiObject, callback) {
        var o = {
            poiObjectId: poiObject.objectId,
            available: true
        }

        internal.getClass(classNameSoldier, o, callback);
    }

    function executeBattle(poiObject) {
        console.log("execute battle for " + JSON.stringify(poiObject));

        getSoldierCountForPoi(poiObject, function(result) {

            console.log("RESPONSE", JSON.stringify(result));

            var countOrc = 0;
            var countHuman = 0;

            var soldiers = result;

            for (var i = 0; i < soldiers.length; i++) {
                var r = soldiers[i];
                if (r.characterType === "CHARACTERTYPE_ORC") {
                    countOrc++;
                } else if (r.characterType === "CHARACTERTYPE_HUMAN") {
                    countHuman++;
                }
            }

            // Find number of soldiers at POIObject for CharacterType ORC
            // Find number of soldiers at POIObject for CharacterType HUMAN

            var winningCharacterType = "";
            var losingCharacterType = "";

            if (countOrc > countHuman) {
                winningCharacterType = "CHARACTERTYPE_ORC";
                losingCharacterType = "CHARACTERTYPE_HUMAN";
            } else if (countHuman > countOrc) {
                winningCharacterType = "CHARACTERTYPE_HUMAN";
                losingCharacterType = "CHARACTERTYPE_ORC";
            } else {
                console.log("### BATTLE ###")
                console.log("### RESULT ###")
                console.log("#### IS A ####")
                console.log("~~~~ TIE ~~~~~")
                console.log("##############")
                console.log("##############")
                console.log("##############")
                return;
            }

            var battle = {
                initiatingUserObjectId: root.userObject.objectId,
                poiObjectId: poiObject.objectId,
                winningCharacterType: winningCharacterType,
                losingCharacterType: losingCharacterType
            }

            internal.postClass(classNameBattle, battle, function(result) {
                console.log("RESULT", "battle completed, killing soldiers...");
                console.log(JSON.stringify(result));

                // Set "available" for battling soldiers to false
                var batchRequest = [];
                for (var j = 0; j < soldiers.length; i++) {
                    var kk = {
                        "method": "POST",
                        "path": "/1/classes/" + root.classNameSoldier,
                        "body": {
                            "available": false,
                            "objectId": soldiers[i].objectId
                        }
                    }
                    batchRequest.push(kk);
                }

                var finalObject = {
                    requests : batchRequest
                }
                internal.post(urlBase + "batch", finalObject, function(result) {
                    console.log("RESPONSE", "battle totally done");
                    console.log(JSON.stringify(result))
                });
            });
        });
    }
}

