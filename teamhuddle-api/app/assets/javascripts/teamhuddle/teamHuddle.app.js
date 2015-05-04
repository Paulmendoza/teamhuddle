(function(angular){
    "use strict";
    
    var BASE_TITLE = "TeamHuddle";

    angular.module('TeamHuddle', [
        'ui.router'
    ])
        .config(routing)
        .run(titleChange);
    
    routing.$inject = ['$stateProvider', '$urlRouterProvider'];
    function routing($stateProvider, $urlRouterProvider) {
        var home = {
                url: '/',
                abstract: true,
                views: {
                    "nav": { 
                        templateUrl: 'nav.html'
                    },
                    "main": {
                        template: '<ui-view/>'
                    }
                }
            },
            index = {
                url: '',
                templateUrl: 'index.html',
                controller: 'HomeCtrl as home'
            },
            about = {
                url: 'about',
                templateUrl: 'about.html',
                controller: 'AboutCtrl as about'
            },
            contact = {
                url: 'contact',
                templateUrl: 'contact.html',
                controller: 'ContactController as contact',
                title: BASE_TITLE + ' - Contact us'
            },
            dropin = {
                url: 'dropin',
                templateUrl: 'dropin.html',
                controller: 'DropinController as dropin'
            };               
        
        // Define default route
        $urlRouterProvider.otherwise("/");
        
        $stateProvider
            .state('home', home)
            .state('home.index', index)
            .state('home.contact', contact)
            .state('home.dropin', dropin)
            .state('home.about', about);
    }
    
    titleChange.$inject = ['$rootScope'];
    function titleChange($rootScope) {

      // Set the title to change on every route change
      $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
          if (toState.title === undefined) toState.title = BASE_TITLE;
          $rootScope.title = toState.title;
      }); 
    }
    
})(angular);