ScrapeApp.service('ScrapeService', ['$http', '$q', '$rootScope', function($http, $q, $rootScope){

    this.GetIdsByCategory = function(categoryId){
        var deferred = $q.defer();

        $http.get('/admin/scrape/get-ids-by-category/'+ categoryId).success(function(resp){
            deferred.resolve(resp.all_ids);
        }).error(function(resp){
            deferred.reject(resp);
        });

        return deferred.promise;
    }

    this.GetDropinsFromIdsChunked = function(allIds){
        // First, we chunk the initial array of ids into more manageable chunks
        var i,j;
        var iChunkSize = 5;
        var chunkedArrays = [];

        for (i = 0,j = allIds.length; i < j; i += iChunkSize) {
            chunkedArrays.push(allIds.slice(i, i + iChunkSize));
        }

        var httpPosts = [];

        var resolvedCount = 0;

        for(i = 0; i < chunkedArrays.length; i++){
            httpPosts.push($http.post('/admin/scrape/get-dropins-by-ids', { dropinIds: chunkedArrays[i]}).then(function(resp){
                resolvedCount++;
                $rootScope.$broadcast('Dropins.ChunkLoaded', {total: httpPosts.length, loaded: resolvedCount});
                return resp.data;
            }));
        }

        $rootScope.$broadcast('Dropins.TotalChunks', httpPosts.length);

        return $q.all(httpPosts)
    }
}]);