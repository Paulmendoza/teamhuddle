BaseApp.controller('landing-page', ['$scope', '$http', function ($scope, $http) {
    $scope.submitted = false;

    $scope.success = false;

    $scope.processing = false;

    $scope.submit = function () {
        $scope.submitted = true;
        $scope.processing = true;

        $http.post('users', {user: {email: $scope.email}}).
            success(function (data, status, headers, config) {
                $scope.success = true;
                $scope.processing = false;
                $scope.user = data;

                // Google Analytics goal event
                ga('send', 'event', 'newsletter-sign-up', 'email-submit', 'beta-newsletter-signup', 1);
            }).
            error(function (data, status, headers, config) {
                $scope.success = false;
                $scope.processing = false;
                $scope.user = data;
            });
    };
}]);
