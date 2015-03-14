var DropinFinder = angular.module('DropinFinder', ['Reviews', 'ngResource', 'ngMap', 'ngAnimate', 'templates', 'ngRoute', 'route-segment', 'view-segment']);

DropinFinder
    .config(['$routeSegmentProvider',
        function ($routeSegmentProvider) {
            $routeSegmentProvider.
                when('/', 'dropin_icons').
                when('/:sport', 'dropin_finder').
                when('/:sport/:dropin_id', 'dropin_finder.dropin_view').

                segment('dropin_icons', {
                    templateUrl: 'dropin_icons.html'
                }).
                segment('dropin_finder', {
                    templateUrl: 'dropin_map_list.html',
                    controller: 'dropins',
                    dependencies: ['sport']
                }).
                within().
                segment('dropin_list', {
                    default: true,
                    templateUrl: "dropin_list.html"
                }).
                segment('dropin_view', {
                    templateUrl: "dropin_view.html",
                    controller: 'dropin'
                }).
                up();

            //COMMENT IN:   disable logging
            //COMMENT OUT:  enable  logging
            //console.log = function() {}
        }]);