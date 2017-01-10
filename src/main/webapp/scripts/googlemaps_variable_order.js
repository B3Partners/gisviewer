/**
 * Created by tariq on 10-1-17.
 */

/**
 * values[] = lat, lon, span Lat, span lon.
 * Change these variables according to changes in the google API
 */
var googlemapsVariableOrder = function () {

    // switch this boolean to change order of coordinates
    var regularOrder = false;

    var variableOrder = {first: 0, second: 1, third: 2, fourth: 3};

    if (!regularOrder) {
        variableOrder.first = 1;
        variableOrder.second = 0;

        variableOrder.third = 3;
        variableOrder.fourth = 2;

    }
    return variableOrder
};