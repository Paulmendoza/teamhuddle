var app = angular.module('app', []);

app.controller('import', ['$scope', '$http', function ($scope, $http) {
        $scope.result = "";
        
        $scope.dropins = [];
        
        $scope.doScrape = function() {
            
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