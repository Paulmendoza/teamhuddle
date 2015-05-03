DropinFinder.controller('dropin', ['$scope','$location', '$routeParams', function ($scope, $location, $routeParams) {

    // Use Case 1: Go to volleyball, view event

    // Use Case 2: Go directly from link
    // -- problem can occur if we do not have that dropin in our list of dropins
    // -- MORE COMMON: fetch that extra dropin instance and it it to list?
    // -- LESS COMMON: then we , and check if it's the correct sport, if it's not the correct sport then change the url
    $scope.dropin = {};
    $scope.dropinWrapper = {};

    $scope.dropinFetchFailed = false;
    $scope.dropinFetchFailed = "";

    // if we don't have this dropin
    $scope.dropin = $scope.getDropinBySportEventId(parseInt($routeParams.dropin_id));

    if($scope.dropin !== undefined) {
        $scope.dropinWrapper = $scope.markerWrappers[$scope.dropin.id];

        $scope.dropinWrapper.infoWindow.toggle(true);
    } else if($scope.loadedOnce){
        $scope.fetchDropin($routeParams.dropin_id)
    }

    $scope.$on('dropinsUpdated', function($scope){
        $scope.currentScope.dropin = $scope.targetScope.getDropinBySportEventId(parseInt($routeParams.dropin_id));
        if($scope.currentScope.dropin &&
            $scope.targetScope.markerWrappers[$scope.currentScope.dropin.id] &&
            $scope.targetScope.markerWrappers.currentlyOpen !== $scope.currentScope.dropin.id){

            $scope.currentScope.dropinWrapper = $scope.targetScope.markerWrappers[$scope.currentScope.dropin.id];

            $scope.currentScope.dropinWrapper.infoWindow.toggle(true);
        } else {
            $scope.targetScope.fetchDropin($routeParams.dropin_id);
        }
        // this is what happens once its loaded
    });

    $scope.$on('dropinFetchFailed', function($scope, reason){
        $scope.currentScope.dropinFetchFailed = true;
        $scope.currentScope.dropinFetchFailedReason = reason;
    });

    //
    $scope.$on('loadDropin', function ($scope, sportEventId){
        $scope.currentScope.dropin = $scope.targetScope.getDropinBySportEventId(sportEventId);
        $scope.currentScope.dropinWrapper = $scope.targetScope.markerWrappers[$scope.currentScope.dropin.sport_event.id];
    });

}]);
