DropinFinder.controller('dropin', ['$scope','$location', '$routeParams', function ($scope, $location, $routeParams) {

    // Use Case 1: Go to volleyball, view event

    // Use Case 2: Go directly from link
    // -- problem can occur if we do not have that dropin in our list of dropins
    // -- MORE COMMON: fetch that extra dropin instance and it it to list?
    // -- LESS COMMON: then we , and check if it's the correct sport, if it's not the correct sport then change the url

    $scope.dropin = {};
    $scope.dropinWrapper = {};
    // if there is nothing open fetch dropin and open it
    if($scope.markerWrappers.currentlyOpen === null || $scope.markerWrappers.currentlyOpen !== $routeParams.dropin_id){

        if($scope.markerWrappers[$routeParams.dropin_id] !== undefined){
            debugger
            $scope.dropinWrapper = $scope.markerWrappers[$routeParams.dropin_id];
            $scope.dropin = $scope.getDropinById(parseInt($routeParams.dropin_id));

            $scope.dropinWrapper.infoWindow.toggle();
        }
        else{
            $scope.fetchDropin($routeParams.dropin_id);
        }

    }

    $scope.$on('dropinsUpdated', function($scope){

        if($scope.targetScope.markerWrappers[$routeParams.dropin_id] !== undefined && $scope.targetScope.markerWrappers.currentlyOpen !== $routeParams.dropin_id){
            $scope.currentScope.dropinWrapper = $scope.targetScope.markerWrappers[$routeParams.dropin_id];
            $scope.currentScope.dropin = $scope.targetScope.getDropinById(parseInt($routeParams.dropin_id));

            $scope.currentScope.dropinWrapper.infoWindow.toggle();
        }
        // this is what happens once its loaded
    });

    //
    $scope.$on('loadDropin', function ($scope, dropinId){
        $scope.currentScope.dropinWrapper = $scope.targetScope.markerWrappers[dropinId];
        $scope.currentScope.dropin = $scope.targetScope.getDropinById(dropinId);
    });

}]);
