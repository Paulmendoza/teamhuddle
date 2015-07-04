var ScrapeApp = angular.module('scrapeApp', ['templates', 'ngRoute', 'route-segment', 'view-segment']);

ScrapeApp.config(['$routeSegmentProvider',
    function ($routeSegmentProvider) {
        $routeSegmentProvider
            //when('/', 'step1').
            //when('/:sport', 'dropin_finder').
            //when('/:sport/dropin/:dropin_id', 'dropin_finder.dropin_view').
            //
            //segment('dropin_icons', {
            //    templateUrl: 'dropin_icons.html.erb'
            //}).
            //segment('dropin_finder', {
            //    templateUrl: 'dropin_map_list.html',
            //    controller: 'dropins',
            //    dependencies: ['sport']
            //}).
            //within().
            //segment('dropin_list', {
            //    default: true,
            //    templateUrl: "dropin_list.html"
            //}).
            //segment('dropin_view', {
            //    templateUrl: "dropin_view.html",
            //    controller: 'dropin'
            //}).
            //up();
    }]);

