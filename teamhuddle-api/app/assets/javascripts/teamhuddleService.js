var app = angular.module('app', ['ngResource', 'ngMap', 'ngAnimate']);


function getStartOfTheWeek(d) {
    d = new Date(d);
    var day = d.getDay();
    var diff = d.getDate() - day + (day === 0 ? -6 : 1); // adjust when day is sunday
    d.setHours(0);
    d.setMinutes(0);
    d.setSeconds(0);
    return new Date(d.setDate(diff));
}

function getEndOfTheWeek(d) {
    d = new Date(d);
    var day = d.getDay();
    var diff = d.getDate() - day + (day === 0 ? 0 : 7); // adjust when day is sunday
    d.setHours(23);
    d.setMinutes(59);
    d.setSeconds(59);
    return new Date(d.setDate(diff));
}

// the dropins service that is expandable with new functions easily
app.service('Dropins', ['$http', '$q', function ($http, $q) {

    var baseUrl = '/api/v1/api_dropins.json?';

    baseUrl += 'from=' + getStartOfTheWeek(new Date()).toISOString();
    baseUrl += '&to=' + getEndOfTheWeek(new Date()).toISOString();
    
    // default get
    this.get = function () {
        return this.fetch(baseUrl);
    };

    this.getBySport = function (sport) {
        var url = baseUrl + '&sport=' + sport;
        return this.fetch(url);
    };

    // 
    this.fetch = function (builtUrl) {
        var deferred = $q.defer();

        $http.get(builtUrl).success(function (data) {
            deferred.resolve(data.dropins);
        }).error(function (data) {
            deferred.reject(data.dropins);
        });

        return deferred.promise;
    };

}]);
