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
    if (window.scrollY > 200) {
        if(faded){
            faded = false;
            //$("nav").fadeTo(200, 1.0, "swing", function () {
            //});
            $("nav").css("background-color", "white");
        }
    }
    else {
        if(!faded){
            faded = true;
            //$( "nav" ).fadeTo( 200 , 0.2, "swing", function() {
            //});
            $("nav").css("background-color", "transparent");
        }

    }
},false);
