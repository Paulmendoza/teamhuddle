BaseApp.controller('landing-page', ['$scope', '$http', function ($scope, $http) {
    $scope.submitted = false;

    $scope.success = false;

    $scope.processing = false;

    $scope.errorMessage = "";

    $scope.submit = function () {
        $scope.submitted = true;
        $scope.processing = true;

        $http.post('beta_testers', {beta_tester: {email: $scope.email}}).
            success(function (data, status, headers, config) {
                $scope.success = true;
                $scope.processing = false;
                $scope.user = data;

                // Google Analytics goal event
                ga('send', 'event', 'newsletter-sign-up', 'email-submit', 'beta-newsletter-signup', 1);
            }).
            error(function (data, status, headers, config) {
                if(status === 422 && data.errors){
                    if(data.errors.email.indexOf("has already been taken") > -1){
                        $scope.errorMessage = "We already have your email in our database! Thanks!"
                    }
                    else if(data.errors.email.indexOf("can't be blank") > -1){
                        $scope.errorMessage = "You have to enter an email!"
                    }
                }
                $scope.success = false;
                $scope.processing = false;
                $scope.user = data;
            });
    };
}]);
