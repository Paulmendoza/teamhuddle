var sportRoutes = ['/volleyball', '/hockey', '/basketball', '/soccer', '/dragonboating'];

app.controller('dropins', ['$scope', '$filter', '$location', 'Dropins', function ($scope, $filter, $location, Dropins) {
        // set my own orderBy filter directive
        var orderBy = $filter('orderBy');
        
        // a dictionary to hold all of the MarkerWrapper objects
        $scope.markerWrappers = {};
        
        // this will hold the id of the marker that is currently open
        $scope.markerWrappers.currentlyOpen = null;

        $scope.weekdaySelect = "All";
        $scope.skillLevelSelect = "All";
        
        // initialize the predicate that sorting will be done through
        $scope.predicate = 'datetime_start.time';
        
        // array that will have all the dropin objects
        $scope.dropins = [];

        // watches dropins and makes sure markers are in sync
        $scope.$watchCollection('dropins', function (newValues, oldValues) {
            
            // delete the old MarkerWrappers
            oldValues.forEach(function (oldDropin) {
                $scope.markerWrappers[oldDropin.id]['marker'].setMap(null);
                delete $scope.markerWrappers[oldDropin.id];
            });

            // add new MarkerWrappers
            newValues.forEach(function (dropin) {
                $scope.markerWrappers[dropin.id] = new MarkerWrapper(dropin);
            });
        });
        
        //watch to see if the location changes and then set the sport accordingly
        $scope.$on('$locationChangeSuccess', function (event) {
            if (sportRoutes.indexOf($location.path()) >= 0) {
                $scope.sport = $location.path().replace("/", "");

                $scope.refreshDropins();
            }
            else {
                $scope.sport = 'no-sport';
                $scope.dropins = [];
            }
        });
        
        // DROPIN CONTROLLER FUNCTIONS:
        // use a deferred promise from the Dropins service to populate the scope
        $scope.refreshDropins = function () {
            Dropins.getBySport($scope.sport).then(
                    function (dropins) {
                        $scope.dropins = orderBy(dropins, $scope.predicate, false);

                        // call a resize because map has moved and recenter it
                        google.maps.event.trigger($scope.map, 'resize');

                        $scope.applyFilters();
                    },
                    function (reason) {
                        alert('Failed: ' + reason);
                    });
        };

        // function which orders by predicate
        $scope.order = function (predicate, reverse) {
            $scope.dropins = orderBy($scope.dropins, predicate, reverse);
        };
        
        // set the maps center to the dropin location
        $scope.centerDropin = function (dropin) {
            $scope.map.panTo(new google.maps.LatLng(dropin.location.lat, dropin.location.long));
            $scope.map.setZoom(11);
        };
        
        
        // applies filters from the URL
        $scope.applyFilters = function () {
            // apply each filter if 'All' isn't selected
            if (typeof $location.search()['day'] !== 'undefined') {
                $scope.dropins = $filter('weekday')($scope.dropins, $location.search()['day']);
                $scope.weekdaySelect = $location.search()['day'];
            }
            else if (typeof $location.search()['day'] === 'undefined') {
                $scope.weekdaySelect = 'All';
            }
            if (typeof $location.search()['skill'] !== 'undefined') {
                $scope.dropins = $filter('skill_level')($scope.dropins, $location.search()['skill']);
                $scope.skillLevelSelect = $location.search()['skill'];
            }
            else if (typeof $location.search()['skill'] !== 'undefined') {
                $scope.skillLevelSelect = 'All';
            }
        };
        
        
        // sets the filter arguments in the URL
        $scope.setFilters = function () {
            if ($scope.weekdaySelect !== 'All') {
                $location.search('day', $scope.weekdaySelect);
            }
            else if ($scope.weekdaySelect === 'All') {
                $location.search('day', null);
            }

            if ($scope.skillLevelSelect !== 'All') {
                $location.search('skill', $scope.skillLevelSelect);
            }
            else if ($scope.skillLevelSelect === 'All') {
                $location.search('skill', null);
            }
        };

        // resets the filter arguments in the URL
        $scope.resetFilters = function () {
            $scope.weekdaySelect = 'All';
            $scope.skillLevelSelect = 'All';
            $location.search('day', null);
            $location.search('skill', null);
        };

        // function to remove an item from the list TODO, GET RID OF THIS EVENTUALLY
        $scope.remove = function (item) {
            var index = $scope.dropins.indexOf(item);
            $scope.dropins.splice(index, 1);
        };
        
        // function to reset the sport
        $scope.resetSport = function () {
            $location.path('/');
            $scope.sport = 'no-sport';
        };
        
        // definition of the marker object that is linked to each dropin event
        // properties: 
        //  isOpen(bool)                        : indicates whether the marker object is open
        //  marker(Object)                      : the google maps marker objecct
        //  infoWindow(Object)                  : the google maps info window object
        //  infoWindow.toggle(function(bool))   : function to toggle an info window
        function MarkerWrapper(dropin) {
            this.isOpen = false;

            this.marker = new google.maps.Marker({
                map: $scope.map,
                position: new google.maps.LatLng(dropin.location.lat, dropin.location.long)
            });

            // the content for the infoWindow is set
            this.infoWindow = new google.maps.InfoWindow({
                content: "<p><b>Location:</b> " + dropin.location.name + "</p>" +
                        "<p><b>Day:</b> " + weekdayEnum[new Date(dropin.datetime_start.time).getDay() - 1] + " </p>" +
                        "<p><b>Skill:</b> " + dropin.sport_event.skill_level + "</p>",
                maxwidth: 600
            });
            
            // redecleration needed to set up listener correctly
            var that = this;
            
            // listener to listen for click event on marker object
            google.maps.event.addListener(that.marker, 'click', function () {
                that.infoWindow.toggle();
            });
            
            // toggles the infoWindow
            // param: keepOpen - if this is passed in the info window will stay open
            this.infoWindow.toggle = function(keepOpen) {
                if(typeof(keepOpen) === 'undefined') keepOpen = false;
                
                if (that.isOpen && !keepOpen) {
                    $scope.markerWrappers.currentlyOpen = null;
                    that.infoWindow.close();
                    that.isOpen = false;
                }
                else {
                    if ($scope.markerWrappers.currentlyOpen !== null) {
                        $scope.markerWrappers[$scope.markerWrappers.currentlyOpen].isOpen = false;
                        $scope.markerWrappers[$scope.markerWrappers.currentlyOpen].infoWindow.close();
                    }

                    $scope.markerWrappers.currentlyOpen = dropin.id;                    
                    that.infoWindow.open($scope.map, that.marker);
                    that.isOpen = true;
                }
            };
        }
        
        // UNUSED HELPER METHOD, COULD BE USERFUL LATER
//        $scope.getSkillSortOrder = function (dropin) {
//            switch (dropin.sport_event.skill_level) {
//                case 'Recreational':
//                    return 1;
//                case 'Beginner':
//                    return 2;
//                case 'Intermediate':
//                    return 3;
//                case 'Advanced':
//                    return 4;
//                default:
//                    return 0;
//            }
//        };

    }]);


// FILTERS
// filter based on a certain weekday
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

var weekdayEnum = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];