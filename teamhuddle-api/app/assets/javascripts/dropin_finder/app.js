var DropinFinder = angular.module('DropinFinder', ['ngResource', 'ngMap', 'ngAnimate', 'templates', 'ngRoute', 'route-segment', 'view-segment']);

DropinFinder.config(['$routeSegmentProvider',
    function($routeSegmentProvider) {
        $routeSegmentProvider.
            when('/', 'dropin_icons').
            when('/:sport', 'dropin_finder').

            segment('dropin_icons', {
                default: true,
                templateUrl: 'dropin_icons.html'
            }).
            segment('dropin_finder', {
                templateUrl: 'dropin_map_list.html',
                controller: 'dropins',
                dependencies: ['sport']
            });

    }]);