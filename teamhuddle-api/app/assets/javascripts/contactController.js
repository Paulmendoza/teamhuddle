app.controller('contact', ['$scope', '$http', function ($scope, $http) {
    $scope.submitted = false;

    $scope.success = false;

    $scope.processing = false;

    $scope.submit = function () {
        $scope.submitted = true;
        $scope.processing = true;

        $http.post('contact_us', $scope.form_data).
            success(function (data, status, headers, config) {
                $scope.success = true;
                $scope.processing = false;
                $scope.data = data;
            }).
            error(function (data, status, headers, config) {
                $scope.success = false;
                $scope.processing = false;
                $scope.data = data;
            });
    };
}]);



