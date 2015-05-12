var BaseApp = angular.module('BaseApp',['ngAnimate']);

BaseApp.animation('.animateSlide', function () {
    return {
        addClass: function (element, className, done) {
            jQuery(element).slideUp(done);
        },
        removeClass: function (element, className, done) {
            jQuery(element).slideDown(done);
        }
    }
});
