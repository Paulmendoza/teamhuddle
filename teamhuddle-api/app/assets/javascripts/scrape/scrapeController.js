ScrapeApp.controller('scrape', ['$scope', 'ScrapeService',  function ($scope, ScrapeService) {
    var categories = {
        'volleyball': 186,
        'hockeyIce':171,
        'soccer':182,
        'basketball':161,
        'dodgeball':165
    }

    $scope.currentIds = [];

    $scope.sport = "none-selected";

    $scope.dropins = [];
    $scope.loadingData = false;

    $scope.progress = {total: 0, loaded: 0};

    $scope.isParsing = false;

    $scope.selectSport = function(sport){
        $scope.sport = sport;

        var categoryId = categories[$scope.sport];

        $scope.loadingData = true;

        ScrapeService.GetIdsByCategory(categoryId).then(function(data){
            $scope.loadingData = false;
            $scope.currentIds = data;
        }, function(data){
            $scope.loadingData = false;
        });
    };

    $scope.resetSport = function(){
        $scope.sport = 'none-selected';
        $scope.currentIds = [];
        $scope.dropins = [];
    };

    $scope.getData = function(){
        $scope.isParsing = true;
        ScrapeService.GetDropinsFromIdsChunked($scope.currentIds).then(function(data){

            for(var i = 0; i < data.length; i++){
                angular.forEach(data[i].scrape, function(dropin){
                    $scope.dropins.push(dropin);
                });
            }
            $scope.isParsing = false;
        });
    };

    $scope.$on('Dropins.ChunkLoaded', function(event, progress){
        $scope.progress = progress;
    })

    $scope.$on('Dropins.TotalChunks', function(event, totalChunks){
        $scope.progress.total = totalChunks;
    })
}]);