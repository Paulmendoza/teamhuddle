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
        controller: function($scope, $rootScope){
            $scope.rating = -1;
            $scope.submitReview = function(){
                ReviewService.CreateReview({
                    sport_event_id: $scope.sportEventId,
                    rating: $scope.rating,
                    review: $scope.review
                }).then(function(resp){
                    $rootScope.$broadcast('ReviewSubmitted', resp.data);
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

Reviews.directive("starRating", function(){
    return{
        restrict: "EA",
        template: "<ul class='rating'>" +
        "  <li ng-repeat='star in stars' ng-class='star'>" +
        "    <i class='fa fa-star'></i>" + //&#9733
        "  </li>" +
        "</ul>",
        scope: {},
        link: function(scope, elem, attrs){
            scope.stars = [];
            for (var i = 0; i < attrs.max; i++) {
                scope.stars.push({
                    filled: i < attrs.ratingValue
                });
            }
        }

    }
})

Reviews.directive("starRatingEdit", function() {
    return {
        restrict: "EA",
        template: "<ul class='rating'>" +
        "  <li ng-repeat='star in stars' ng-class='star' class='clickable' ng-click='toggle($index)'>" +
        "    <i class='fa fa-star'></i>" + //&#9733
        "  </li>" +
        "</ul>",
        scope: {
            ratingValue: "=",
            max: "=",
            onRatingSelected: "&"
        },
        link: function (scope, elem, attrs) {
            var updateStars = function () {
                scope.stars = [];
                for (var i = 0; i < scope.max; i++) {
                    scope.stars.push({
                        filled: i < scope.ratingValue
                    });
                }
            };
            scope.toggle = function (index) {
                scope.ratingValue = index + 1;
                scope.onRatingSelected({
                    rating: index + 1
                });
            };
            scope.$watch("ratingValue", function (oldVal, newVal) {
                if (newVal) {
                    updateStars();
                }
            });
        }
    }
});
