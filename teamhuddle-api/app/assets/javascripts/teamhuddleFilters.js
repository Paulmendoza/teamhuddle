// FILTERS
// filter based on a certain weekday
app.filter('weekday', ['$filter', function ($filter) {
    return function (sport_events, day) {
        var retn = [];

        angular.forEach(sport_events, function (sport_event) {
            if ($filter('date')(sport_event.datetime_start, 'EEEE') === day) {

                retn.push(sport_event);
            }
        });

        return retn;
    };
}]);

// filter based on skill level
app.filter('skill_level', function () {
    return function (sport_events, skill) {
        var retn = [];

        angular.forEach(sport_events, function (event) {

            if (event.sport_event.skill_level === skill) {
                retn.push(event);
            }
        });

        return retn;
    };
});
