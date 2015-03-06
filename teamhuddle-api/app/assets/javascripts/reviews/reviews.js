var Reviews = angular.module('Reviews', []);

Reviews.service('ReviewsService', ['$http', function($http){
    this.CreateReview = function(review){
        return $http.post('/reviews', review);
    }

    this.GetReviewsForDropin = function(sportEventId){
        return $http.get('/reviews/' + sportEventId + '.json');
    }
}]);

Reviews.directive('newReview', ['ReviewsService', function(ReviewService){
    return {
        restrict: 'E',
        templateUrl: 'new_review.html',
        scope: {
            userId: '=userId',
            sportEventId: '=sportEventId'
        },
        controller: function($scope){
            $scope.submitReview = function(){
                $scope.userId = !!currentUser ? currentUser.id : null;
                ReviewService.CreateReview({
                    user_id: $scope.userId,
                    sport_event_id: $scope.sportEventId,
                    rating: $scope.rating,
                    review: $scope.review
                }).then(function(resp){
                    // todo handle this somehow
                })
            }
        }
    }
}]);

Reviews.directive('playerReview', ['ReviewsService', function(ReviewService){
    return {
        restrict: 'E',
        templateUrl: 'player_review.html',
        scope: {
            review: '=review'
        }
    }
}]);
