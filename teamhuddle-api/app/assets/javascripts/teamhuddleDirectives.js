app.directive('slideToggle', function() {
    return {
        restrict: 'A',
        scope:{
            isOpen: "=slideToggle"
        },
        link: function(scope, element, attr) {
            var slideDuration = parseInt(attr.slideToggleDuration, 10) || 200;
            if (attr.startShown=="false") {
                element.hide();
            }
            scope.$watch('isOpen', function(newVal,oldVal){
                if(newVal !== oldVal){
                    element.stop().slideToggle(slideDuration);
                }
            });
        }
    };
});

app.animation('.animateSlide', function() {
    return {
        addClass: function(element, className, done) {
            jQuery(element).slideUp(done);
        },
        removeClass: function(element, className, done) {
            jQuery(element).slideDown(done);
        }
    }
});