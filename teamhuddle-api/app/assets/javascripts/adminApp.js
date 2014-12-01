var app = angular.module('app', ['ngMap']);

app.controller('import', ['$scope', '$http', function ($scope, $http) {
        $scope.result = "";

        $scope.dropins = [];

        $scope.doScrape = function () {

            $http.post('scrape', {api_url: $scope.api_url}).
                    success(function (data, status, headers, config) {
                        $scope.result = "it worked";
                        $scope.dropins = data.dropins;
                    }).
                    error(function (data, status, headers, config) {
                        // called asynchronously if an error occurs
                        // or server returns response with an error status.
                        $scope.result = "it DID NOT worked";
                    });
        };
    }]);

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
                $scope.result.long = result[0].geometry.location.B;
            });
            
            if($scope.result.address === before_search){
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