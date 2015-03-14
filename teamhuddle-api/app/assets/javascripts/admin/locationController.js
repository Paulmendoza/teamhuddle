app.controller('location-create', ['$scope', 'GeoCoder', function ($scope, GeoCoder) {
    $scope.result = {};

    $scope.result.address = '';

    var searchedFor = '';

    $scope.search = function () {
        searchedFor = $scope.searchInput;
        var bounds = new google.maps.LatLngBounds(
            new google.maps.LatLng(49.013143, -123.329683),
            new google.maps.LatLng(49.470354, -122.016295)
        );

        var before_search = $scope.result.address;

        GeoCoder.geocode({address: $scope.searchInput, bounds: bounds}).then(function (result) {
            $scope.result.address = result[0].formatted_address;
            $scope.result.lat = result[0].geometry.location.k;
            $scope.result.long = result[0].geometry.location.D;
        });

        if ($scope.result.address === before_search) {
            $scope.result.address = "couldn't find it";
        }

    };

    $scope.populateForm = function () {
        $scope.name = searchedFor;
        $scope.lat = $scope.result.lat;
        $scope.long = $scope.result.long;
        $scope.address = $scope.result.address;

    };
}]);