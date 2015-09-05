/* @flow weak */

window.addEventListener(
    'load',
    function () {
        var app = Elm.fullscreen(
            Elm.Main,
            {
                uriHashSignal : document.location.hash,
                orientationSignal : null,
                orientationErrorSignal : null,
                geolocationSignal : null,
                geolocationErrorSignal : null
            }
        );

        var sendHash = function (event) {
            app.ports.uriHashSignal.send(document.location.hash);
        };

        var sendOrientation = function (orientation) {
            app.ports.orientationSignal.send(orientation);
        };

        var sendPosition = function (position) {
            console.log("Got position", position);
            app.ports.geolocationSignal.send(position);
        };

        var sendPositionError = function (positionError) {
            console.error("Got position error", positionError);
            app.ports.geolocationErrorSignal.send(positionError);
        };

        navigator.geolocation.getCurrentPosition(sendPosition);
        navigator.geolocation.watchPosition(
            sendPosition,
            sendPositionError,
            {maximumAge : 1000}
        );;

        window.addEventListener('popstate', sendHash, false);

        if (window.DeviceOrientationEvent) {
            window.addEventListener('deviceorientation', sendOrientation, false);
        } else {
            app.ports.orientationErrorSignal.send(positionError);
        };
    },
    false
);
