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

    $scope.isDoneParsing = false;

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
        $scope.progress.total = 0;
        $scope.progress.loaded = 0;
        $scope.isDoneParsing = false;
    };

    $scope.getData = function(){
        $scope.isParsing = true;
        $scope.progress.total = $scope.currentIds.length;
        ScrapeService.GetDropinsFromIdsChunked($scope.currentIds).then(function(data){
            $scope.isParsing = false;
            $scope.isDoneParsing = true;
        });
    };

    $scope.$on('Dropins.ChunkLoaded', function(event, payload){
        $scope.progress = payload.progress;

        angular.forEach(payload.chunk.scrape, function(dropin){
            $scope.dropins.push(dropin);
        });
    });
}]);