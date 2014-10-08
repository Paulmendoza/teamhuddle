var map = {};

//initializeMap();

app.controller('dropins', ['$scope', '$filter', 'Dropins', function ($scope, $filter, Dropins) {
        var orderBy = $filter('orderBy');
        $scope.dropins = [
            {
                datetime_start: { time: ''} ,
                datetime_end: { time: ''} ,
                event: { name: ''},
                location: { name: ''}
            }
        ];
        
        $scope.remove = function (item) {
            var index = $scope.dropins.indexOf(item);
            $scope.dropins.splice(index, 1);
        };

        // use a deferred promise from the Dropins service to populate the scope
        $scope.refresh = function () {
            Dropins.get().then(
                    function (dropins) {
                        $scope.dropins = orderBy(dropins, 'datetime_start');
                    },
                    function (reason) {
                        alert('Failed: ' + reason);
                    });
        };

        // orders by predicate
        $scope.order = function (predicate, reverse) {
            $scope.dropins = orderBy($scope.dropins, predicate, reverse);
        };
        
        $scope.refresh();

        $scope.centerDropin = function(dropin){
            $scope.map.panTo(new google.maps.LatLng(dropin.location.lat, dropin.location.long));
            $scope.map.setZoom(11);
        };
        
        $scope.$watch($scope.weekdaySelect)
        console.log();
    }]);

app.filter('weekdayFilter', function() {
    return function(items) {
        var retn = [];

        angular.forEach(items, function(item){
            if((new Date().getFullYear()) - (new Date(+item.InfoDetails[0].FromDt.substring(6, item.InfoDetails[0].FromDt.length - 2)).getFullYear()) >= 3){
              retn.push(item); 
            }
        });

        console.log(retn);
        // return items.slice().reverse();
        return retn;
    };
});