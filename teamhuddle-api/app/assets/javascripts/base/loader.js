$(document).ready(function(){
    $(".button-collapse").sideNav();
});
var faded = true;
window.addEventListener("scroll", function() {
    if (window.scrollY > 10) {
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