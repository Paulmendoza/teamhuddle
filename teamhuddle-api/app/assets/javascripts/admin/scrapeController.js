app.controller('scrape', ['$scope', '$http', function ($scope, $http) {
    $scope.result = "";

    $scope.dropins = [];
    $scope.loadingData = false;

    $scope.getData = function(){

        $scope.loadingData = true;
        $http.get('/admin/scrape/get-data').then(function(resp){

            $scope.loadingData = false;
            $scope.dropins = resp.data.scrape;
            debugger
        });
    };
}]);