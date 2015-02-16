// FILTERS
// filter based on a certain weekday
DropinFinder.filter('weekday', ['$filter', function ($filter) {
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
DropinFinder.filter('skill_level', function () {
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

String.prototype.isEmpty = function() {
    return (this.length === 0 || !this.trim());
};

DropinFinder.filter('empty_to_na', function () {
    return function (string) {
        if(string === null || string === undefined || string.isEmpty()) {
            return 'N/A';
        } else {
            return string;
        }
    };
});

DropinFinder.filter('capitalize', function() {
    return function(input, all) {
        return (!!input) ? input.replace(/([^\W_]+[^\s-]*) */g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();}) : '';
    }
});


