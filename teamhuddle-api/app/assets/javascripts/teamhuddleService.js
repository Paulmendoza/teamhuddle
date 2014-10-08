var app = angular.module('app', ['ngResource', 'ngMap', 'ngAnimate']);


// the dropins service that is expandable with new functions easily
app.service('Dropins', function($http, $q){
    
    var url = '/api/v1/dropins.json?from=2014-9-29&to=2014-10-5';
    
    this.get = function(){
        var deferred = $q.defer();
        
        $http.get(url).success(function(data){
            deferred.resolve(data.dropins);
        }).error(function(data) {
            deferred.reject(data.dropins);
        });
        
        return deferred.promise;
    };
    
});
