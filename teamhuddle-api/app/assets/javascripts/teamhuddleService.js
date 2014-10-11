var app = angular.module('app', ['ngResource', 'ngMap', 'ngAnimate']);


// the dropins service that is expandable with new functions easily
app.service('Dropins', function($http, $q){
    
    var baseUrl = '/api/v1/dropins.json?';
            
            
    baseUrl += 'from=' + moment().startOf('week').format();        
    baseUrl += '&to=' + moment().endOf('week').format(); 
    
    
    // default get
    this.get = function(){
        return this.fetch(baseUrl);
    };
    
    this.getBySport = function(sport){
        var url = baseUrl + '&sport=' + sport;
        return this.fetch(url);
    };
    
    // 
    this.fetch = function(builtUrl) {
        var deferred = $q.defer();
        
        $http.get(builtUrl).success(function(data){
            deferred.resolve(data.dropins);
        }).error(function(data) {
            deferred.reject(data.dropins);
        });
        
        return deferred.promise;
    };
    
});
