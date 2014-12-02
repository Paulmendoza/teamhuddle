var sportRoutes = ['/volleyball', '/hockey', '/basketball', '/soccer', '/dragonboat'];

app.controller('dropins', ['$scope', '$filter', '$location', '$compile', 'Dropins', function ($scope, $filter, $location, $compile, Dropins) {
        // set my own orderBy filter directive
        var orderBy = $filter('orderBy');
        
        $scope.mapMobileToggle = false;

        // for displaying all list items as verbose or non verbose format
        $scope.format = 'items';

        $scope.isSelected = function (dropin_id) {
            return $scope.format === 'items' || $scope.markerWrappers.currentlyOpen === dropin_id;
        };

        // a dictionary to hold all of the MarkerWrapper objects
        $scope.markerWrappers = {};

        // this will hold the id of the marker that is currently open
        $scope.markerWrappers.currentlyOpen = null;

        // initialize the predicate that sorting will be done through
        $scope.predicate = 'datetime_start';

        // array that will have all the dropin objects
        $scope.dropins = [];


        /**** DROPIN EVENTS/WATCHERS: ****/
        /*******************************************/

        // watches dropins and makes sure markers are in sync
        $scope.$watchCollection('dropins', function (newValues, oldValues) {

            console.log("Old length = " + oldValues.length);
            console.log("New length = " + newValues.length);

            // delete the old MarkerWrappers
            oldValues.forEach(function (oldDropin) {
                $scope.markerWrappers[oldDropin.id]['marker'].setMap(null);
                delete $scope.markerWrappers[oldDropin.id];

                console.log("Deleting marker: " + oldDropin.id);
            });

            // add new MarkerWrappers
            $scope.dropins.forEach(function (dropin) {
                if (typeof ($scope.markerWrappers[dropin.id]) === 'undefined') {
                    $scope.markerWrappers[dropin.id] = new MarkerWrapper(dropin);
                    console.log("Adding marker: " + dropin.id);
                }
            });

            // if the currently open id is no longer contained in the wrappers then obviously set it to null, as it can't be open
            if (typeof ($scope.markerWrappers[$scope.markerWrappers.currentlyOpen]) === 'undefined') {
                $scope.markerWrappers.currentlyOpen = null;
            }
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

        
        
        /**** DROPIN CONTROLLER FUNCTIONS: ****/
        /**************************************/

        // use a deferred promise from the Dropins service to populate the scope
        $scope.refreshDropins = function () {
            $scope.$emit("loadMap");
            Dropins.getBySport($scope.sport).then(
                    function (dropins) {
                        $scope.dropins = orderBy(dropins, $scope.predicate, false);

                        $scope.resizeMap();

                        $scope.applyFilters();

                        if ($scope.dropins.length > 3) {
                            $scope.format = 'table';
                        }
                        else {
                            $scope.format = 'items';
                        }
                    },
                    function (reason) {
                        alert('Failed: ' + reason);
                    });
        };
        
        $scope.resizeMap = function () {            
            // set a minor timeout to fix load issues
            window.setTimeout(function(){
                google.maps.event.trigger($scope.map, 'resize');
            },100);
        };
        
        $scope.switchToMap = function () {   
            $scope.mapMobileToggle = !$scope.mapMobileToggle;
            $scope.resizeMap();
            window.setTimeout(function(){
                if($scope.markerWrappers.currentlyOpen !== null){
                    var currentlyOpen = $scope.markerWrappers.currentlyOpen;
                    $scope.markerWrappers[currentlyOpen].infoWindow.toggle();
                    $scope.markerWrappers[currentlyOpen].infoWindow.toggle();
                }                
            },250);
        };
        
        $scope.switchToList = function () {   
            $scope.mapMobileToggle = !$scope.mapMobileToggle;
            window.setTimeout(function(){
                if($scope.markerWrappers.currentlyOpen !== null){
                    var currentlyOpen = $scope.markerWrappers.currentlyOpen;
                    $scope.markerWrappers[currentlyOpen].infoWindow.toggle();
                    $scope.markerWrappers[currentlyOpen].infoWindow.toggle();
                }                
            },250);
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
            else {
                $scope.weekdaySelect = undefined;
            }
            if (typeof $location.search()['skill'] !== 'undefined') {
                $scope.dropins = $filter('skill_level')($scope.dropins, $location.search()['skill']);
                $scope.skillLevelSelect = $location.search()['skill'];
            }
            else {
                $scope.skillLevelSelect = undefined
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
            $scope.weekdaySelect = undefined;
            $scope.skillLevelSelect = undefined;
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

        $scope.moreDropinInfo = function () {
            debugger;
        };

        /**** INNER CLASS: ****/
        /***********************/
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
                //icon: "<%= asset_path('Hockey-MapMarker.png') %>",
                position: new google.maps.LatLng(dropin.location.lat, dropin.location.long)
            });
            
            var htmlContent = "<div class='info-window'>" +
                        "<h5>" + dropin.location.name + "</h5>" +
                        "<p>" + dropin.location.address + "</p>" +
                        "<p>" + dropin.organization.phone + "</p>" +
                        "<div class='hidden-xs hidden-sm'>" + //hide extra stuff on mobile, instead show a button to go to the list
                            "<div class='col-md-7 col-sm-7'>" +
                                "<p><b>Day:</b> " + $filter('date')(dropin.datetime_start, 'EEEE') + " </p>" +
                                "<p><b>Skill:</b> " + dropin.sport_event.skill_level + "</p>" +
                            "</div>" +
                            "<div class='col-md-5 col-sm-5'>" +
                                "<p><b>Price:</b> " + $filter('currency')(dropin.sport_event.price_per_one) + "</p>" +
                                "<p><b>Time:</b> " + $filter('date')(dropin.datetime_start, 'h:mm a') + " - " + $filter('date')(dropin.datetime_end, 'h:mm a') + "</p>" +
                            "</div>" +
                            "<br><br><br><br><br>" + 
                        "</div>" +
                        "<div class='hidden-lg hidden-md'>" +
                            "<button class='btn' ng-click='switchToList()'>more info</button>" +
                            "<br><br><br>" + 
                        "</div>" +
                        "</div>";
            
            var compiled = $compile(htmlContent)($scope);
            
            // the content for the infoWindow is set
            this.infoWindow = new google.maps.InfoWindow({
                content: compiled[0],
                maxwidth: 200
            });

            // redecleration needed to set up listener correctly
            var that = this;

            // listener to listen for click event on marker object
            google.maps.event.addListener(that.marker, 'click', function () {
                that.infoWindow.toggle();
            });

            // toggles the infoWindow
            // param: keepOpen - if this is passed in the info window will stay open
            this.infoWindow.toggle = function (keepOpen) {
                if (typeof (keepOpen) === 'undefined')
                    keepOpen = false;

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

                    // scroll to logic here
                    var scrollPos = $('#dropin-' + dropin.id).offset().top;

                    // if the element would fall into the height of the window 
                    // minus some buffer then just scroll to the top
                    if (scrollPos < window.innerHeight - 150) {
                        $('body').animate({scrollTop: 0}, 'fast');
                    }
                    // otherwise scroll to the element minus a buffer so it will always show on screen
                    else {
                        $('body').animate({scrollTop: scrollPos - 175}, 'fast');
                    }
                }

                if (!$scope.$$phase) {
                    $scope.$apply();
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
