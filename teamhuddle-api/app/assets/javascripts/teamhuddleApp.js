var map = {};

var sportRoutes = ['/volleyball', '/hockey', '/basketball', '/soccer', '/dragonboat'];

app.controller('dropins', ['$scope', '$filter', '$location', 'Dropins', function ($scope, $filter, $location, Dropins) {

        //watch to see if the location changes and then set the sport accordingly
        $scope.$on('$locationChangeSuccess', function(event){
            if (sportRoutes.indexOf($location.path()) >= 0) {
                $scope.sport = $location.url().replace("/", "");
            }
            else {
                $scope.sport = 'no-sport';
            }
        });

        var orderBy = $filter('orderBy');
        $scope.dropins = [];
        $scope.predicate = 'datetime_start.time';

        // use a deferred promise from the Dropins service to populate the scope
        $scope.refreshDropins = function () {
            $scope.weekdaySelect = "All";
            $scope.skillLevelSelect = "All";
            Dropins.getBySport($scope.sport).then(
                    function (dropins) {
                        $scope.dropins = orderBy(dropins, $scope.predicate, false);

                        // call a resize because map has moved and recenter it
                        google.maps.event.trigger($scope.map, 'resize');

                        // reset the center to the first object in the array
                        if ($scope.dropins.length > 0) {
                            $scope.centerDropin($scope.dropins[0])
                        }
                    },
                    function (reason) {
                        alert('Failed: ' + reason);
                    });
        };


        // orders by predicate
        $scope.order = function (predicate, reverse) {
            $scope.dropins = orderBy($scope.dropins, predicate, reverse);
        };

        $scope.getSkillSortOrder = function (dropin) {
            switch (dropin.sport_event.skill_level) {
                case 'Recreational':
                    return 1;
                case 'Beginner':
                    return 2;
                case 'Intermediate':
                    return 3;
                case 'Advanced':
                    return 4;
                default:
                    return 0;
            }
        };

        $scope.centerDropin = function (dropin) {
            $scope.map.panTo(new google.maps.LatLng(dropin.location.lat, dropin.location.long));
            $scope.map.setZoom(11);
        };


        // gets all data and applies requested filters 
        $scope.applyFilters = function () {
            Dropins.getBySport($scope.sport).then(
                    function (dropins) {

                        // apply each filter if 'All' isn't selected
                        if ($scope.weekdaySelect !== 'All') {
                            dropins = $filter('weekday')(dropins, $scope.weekdaySelect);
                        }
                        if ($scope.skillLevelSelect !== 'All') {
                            dropins = $filter('skill_level')(dropins, $scope.skillLevelSelect);
                        }

                        $scope.dropins = dropins;
                    },
                    function (reason) {
                        alert('Failed: ' + reason);
                    });
        };

        // function to remove an item from the list
        $scope.remove = function (item) {
            var index = $scope.dropins.indexOf(item);
            $scope.dropins.splice(index, 1);
        };


    }]);

// filters based on weekday
app.filter('weekday', function ($filter) {
    return function (sport_events, day) {
        var retn = [];

        angular.forEach(sport_events, function (sport_event) {
            if ($filter('date')(sport_event.datetime_start.time, 'EEEE') === day) {

                retn.push(sport_event);
            }
        });

        return retn;
    };
});

// filters based on skill level
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
