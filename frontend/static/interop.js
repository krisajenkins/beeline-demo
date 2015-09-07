/*global Elm */

window.addEventListener(
    'load',
    function () {
        var app = Elm.fullscreen(
            Elm.Main,
            {
                orientationSignal : null,
                orientationErrorSignal : null,
                geolocationSignal : null,
                geolocationErrorSignal : null
            }
        );

        navigator.geolocation.getCurrentPosition(app.ports.geolocationSignal.send);
        navigator.geolocation.watchPosition(
            app.ports.geolocationSignal.send,
            app.ports.geolocationErrorSignal.send,
            {maximumAge : 1000}
        );

        if (window.DeviceOrientationEvent) {
            window.addEventListener(
                'deviceorientation',
                app.ports.orientationSignal.send,
                false
            );
        } else {
            app.ports.orientationErrorSignal.send("Device does not support orientation checks.");
        };
    },
    false
);
