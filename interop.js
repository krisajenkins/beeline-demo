/*global Elm */

window.addEventListener(
    'load',
    function () {
        var app = Elm.App.fullscreen();

        if ("geolocation" in navigator) {
            navigator.geolocation.getCurrentPosition(app.ports.geolocation.send);
            navigator.geolocation.watchPosition(
                app.ports.geolocation.send,
                app.ports.geolocationError.send,
                {maximumAge : 1000}
            );
        } else {
            app.ports.geolocationError.send("Device does not support geolocation checks.");
        }

        if (window.DeviceOrientationEvent) {
            window.addEventListener(
                'deviceorientation',
                app.ports.orientation.send,
                false
            );
        } else {
            app.ports.orientationError.send("Device does not support orientation checks.");
        };
    },
    false
);
