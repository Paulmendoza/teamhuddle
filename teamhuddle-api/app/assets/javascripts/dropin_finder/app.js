var DropinFinder = angular.module('DropinFinder', ['ngResource', 'ngMap', 'ngAnimate', 'templates', 'ngRoute']);

DropinFinder.config(['$routeProvider',
    function($routeProvider) {
        $routeProvider.
            when('/test-route', {
                templateUrl: 'test.html'
            });
    }]);