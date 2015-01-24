var DropinFinder = angular.module('DropinFinder', ['ngResource', 'ngMap', 'ngAnimate', 'templates', 'ngRoute']);

DropinFinder.config(['$routeProvider', '$locationProvider',
    function($routeProvider, $locationProvider) {
        $routeProvider.
            when('/', {
                templateUrl: 'dropin_icons.html'
            }).
            when('/volleyball', {
                templateUrl: 'dropin_map_list.html',
                controller: 'dropins'
            }).
            when('/basketball', {
                templateUrl: 'dropin_map_list.html',
                controller: 'dropins'
            }).
            when('/hockey', {
                templateUrl: 'dropin_map_list.html',
                controller: 'dropins'
            }).
            when('/soccer', {
                templateUrl: 'dropin_map_list.html',
                controller: 'dropins'
            }).
            when('/test-route', {
                templateUrl: 'test.html',
                controller: 'test'
            });

        //$locationProvider.html5Mode(true);
        //{
        //    enabled: true,
        //    requireBase: false
        //});
    }]);