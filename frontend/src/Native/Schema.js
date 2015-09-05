/*global Elm */
Elm.Native = Elm.Native || {};
Elm.Native.Schema = {};
Elm.Native.Schema.make = function(localRuntime){
    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.Storage = localRuntime.Native.Storage || {};

    if (localRuntime.Native.Storage.values){
        return localRuntime.Native.Storage.values;
    }

    var Task = Elm.Native.Task.make(localRuntime);

    var requestLocation = Task.asyncFunction(function (callback) {
        navigator.geolocation.getCurrentPosition(function (position) {
            callback(Task.succeed(position));
        });
    });

    return {
        requestLocation : requestLocation

    };
};
