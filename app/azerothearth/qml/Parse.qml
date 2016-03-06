import QtQuick 2.4

Item {
    id: root

    readonly property bool isUserAuthenticated: internal.sessionToken !== ""

    property string version: "1"
    property string urlBase: "https://api.parse.com/"+version+"/"
    property string urlClasses: urlBase + "classes/"
    property string urlUsers: urlBase + "users/"
    property string urlUserLogin: urlBase + "login/"

    property string classNamePoi: "poi"

    property string appId: "UPJFfR8GO7kXYFPicuKK0mdakfcL73vU4PwzsiV9"
    property string apiKey: "lUbm8jUTe7efq4dbgzV88bMoZ1G2kE1TPDB6V0Sk"

    property string errorStringUsernameTaken: "USERNAME_ALREADY_TAKEN"
    property string errorStringUsernameNotDefined: "USERNAME_NOT_DEFINED"
    property string errorStringPasswordNotDefined: "PASSWORD_NOT_DEFINED"
    property string errorStringUsernameTooShort: "USERNAME_TOO_SHORT"
    property string errorStringPasswordTooShort: "PASSWORD_TOO_SHORT"


    function foursquare_scrapeMonuments(callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", foursquare.urlVenues, true);
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

    QtObject {
        id: foursquare

        property string clientId: "ZTNRJYVFMKVOKLNIMBSRN4CXRJJDD141CRJCEYZBBTV13SCL"
        property string clientSecret: "TEQGO515PTXVXHRIFNAKGWFYSLHRYPKZIX5VGTPSLJ5KTNWC"

        property string urlSuffix: "&client_id=" + clientId + "&client_secret=" + clientSecret + "&v=20160305"
        property string urlVenues: "https://api.foursquare.com/v2/venues/search/?ll=37.773972,-122.431297&categoryId=4bf58dd8d48988d12d941735" + urlSuffix
    }

    QtObject {
        id: internal

        property string sessionToken: ""

        function __buildXhr(httpType, url, obj, callback) {
            var xhr = new XMLHttpRequest();

            if (httpType === "GET") {
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
            xhr.setRequestHeader("Content-Type", "application/json");

            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    var result = JSON.parse(xhr.responseText);
                    var error = true;
                    if (result.objectId) {
                        error = false;
                    }
                    if (callback) {
                        callback(result, error);
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
            get(urlClasses + className, obj, callback);
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

        if (userObject.username.length < 3) {
            callback({ status: 0, errorString: root.errorStringUsernameTooShort });
            return;
        }

        if (userObject.password.length < 3) {
            callback({ status: 0, errorString: root.errorStringPasswordTooShort });
            return;
        }

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

        internal.get(urlUserLogin, o, function(result, error) {
            var errorString = "";
            if (error) {
                if (result.code == 201 || result.code == 101) {
                    errorString = "PASSWORD_INCORRECT";
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

                callback({
                             status: 1,
                             result: result,
                             errorString: errorString
                         });
            }
        });
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
}

