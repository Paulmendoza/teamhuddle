var map = {};

//initializeMap();

app.controller('dropins', ['$scope', '$filter', 'Dropins', function ($scope, $filter, Dropins) {
        var orderBy = $filter('orderBy');
        $scope.dropins = [
            {
                datetime_start: {time: ''},
                datetime_end: {time: ''},
                event: {name: ''},
                location: {name: ''}
            }
        ];

        $scope.remove = function (item) {
            var index = $scope.dropins.indexOf(item);
            $scope.dropins.splice(index, 1);
        };

        // use a deferred promise from the Dropins service to populate the scope
        $scope.refreshDropins = function () {
            $scope.weekdaySelect = "All";
            Dropins.get().then(
                    function (dropins) {
                        $scope.dropins = orderBy(dropins, 'datetime_start.time');
                    },
                    function (reason) {
                        alert('Failed: ' + reason);
                    });
        };

        // orders by predicate
        $scope.order = function (predicate, reverse) {
            $scope.dropins = orderBy($scope.dropins, predicate, reverse);
        };

        $scope.refreshDropins();

        $scope.centerDropin = function (dropin) {
            $scope.map.panTo(new google.maps.LatLng(dropin.location.lat, dropin.location.long));
            $scope.map.setZoom(11);
        };



        $scope.filterDays = function () {
            if($scope.weekdaySelect === "All"){
                $scope.refreshDropins();
            }
            else{
               Dropins.get().then(
                    function (dropins) {
                        $scope.dropins = $filter('weekday')(dropins, $scope.weekdaySelect);
                    },
                    function (reason) {
                        alert('Failed: ' + reason);
                    }); 
            }
            
        }

    }]);


app.filter('weekday', function ($filter) {
    return function (sport_events, day) {
        var retn = [];
        
        angular.forEach(sport_events, function (sport_event) {
            if ($filter('date')(sport_event.datetime_start.time, 'EEEE') === day) {
                
                retn.push(sport_event);
            }
        });

        console.log(retn);
        // return items.slice().reverse();
        return retn;
    };
});


