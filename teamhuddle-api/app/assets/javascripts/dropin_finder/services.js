//COMMENT IN:   disable logging
//COMMENT OUT:  enable  logging 
//console.log = function() {}

Date.prototype.addDays = function(days) {
    this.setDate(this.getDate() + days);
    return this;
};

function getNextDay(dayOfWeek) {
    var date = new Date();
    date.setDate(date.getDate() + (dayOfWeek + 7 - date.getDay()) % 7);
    return date;
}

function getDayFromString(stringDay){
    var weekday = {};
    weekday["Sunday"]=  0;
    weekday["Monday"] = 1;
    weekday["Tuesday"] = 2;
    weekday["Wednesday"] = 3;
    weekday["Thursday"] = 4;
    weekday["Friday"] = 5;
    weekday["Saturday"] = 6;

    return weekday[stringDay];
}

function getNextDayFromString(stringDay){
    var date = getNextDay(getDayFromString(stringDay));
    date.setHours(0);
    date.setMinutes(0);
    date.setSeconds(0);
    return date;
}


// the dropins service that is expandable with new functions easily
DropinFinder.service('Dropins', ['$http', '$q', function ($http, $q) {

    var baseUrl = '/api/v1/api_dropins.json';

    // default get (gets events for the week)
    this.get = function () {
        return fetch(baseUrl);
    };

    this.GetBySportWithFilters = function (sport, filters) {
        var url = baseUrl + '?sport=' + sport;

        var dateFrom = new Date(Date.now());

        if(filters['day']){
            url += buildUrlForNextDay(filters['day']);
        }
        else{
            url += '&from=' + dateFrom.toISOString();
            url += '&to=' + dateFrom.addDays(7).toISOString();
        }

        if(filters['skill']){
            url += '&skill_level=' + filters['skill'];
        }

        return fetch(url);
    };

    function fetch(builtUrl) {
        var deferred = $q.defer();

        $http.get(builtUrl).success(function (data) {
            deferred.resolve(data.dropins);
        }).error(function (data) {
            deferred.reject(data.dropins);
        });

        return deferred.promise;
    };

    function buildUrlForNextDay(dayString){
        var nextDay = getNextDayFromString(dayString);

        var url = "&from=" + nextDay.toISOString();

        nextDay.setHours(23);
        nextDay.setMinutes(59);
        nextDay.setSeconds(59);
        url += "&to=" + nextDay.toISOString();

        return url;
    }
}]);

DropinFinder.service('Admins', ['$http', '$q', function ($http, $q) {
    this.signed_in = function(){
        var deferred = $q.defer();

        $http.get('/admin/admin_signed_in.json')
            .success(function (data) {
                deferred.resolve(data.signed_in);
            }).error(function (data) {
                deferred.reject(data.signed_in);
            });
        return deferred.promise
    }
}]);
