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
var faded = true;
window.addEventListener("scroll", function() {
    if (window.scrollY > 100) {
        if(faded){
            faded = false;
            $("nav").css("background-color", "white");
        }
    }
    else {
        if(!faded){
            faded = true;
            $("nav").css("background-color", "transparent");
        }
    }
},false);