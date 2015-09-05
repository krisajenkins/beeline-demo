/* @flow weak */

window.addEventListener(
    'load',
    function () {
        var app = Elm.fullscreen(
            Elm.Main,
            {
                uriHashSignal : document.location.hash,
                geolocationSignal : null,
                geolocationErrorSignal : null
            }
        );

        var sendHash = function (event) {
            app.ports.uriHashSignal.send(document.location.hash);
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
        navigator.geolocation.watchPosition(sendPosition,sendPositionError,{});;

        window.addEventListener('popstate', sendHash, false);
    },
    false
);
