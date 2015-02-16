// FILTERS
// filter based on a certain weekday

String.prototype.isEmpty = function() {
    return (this.length === 0 || !this.trim());
};

DropinFinder.filter('empty_to_na', function () {
    return function (string) {
        if(string === null || string === undefined || string.isEmpty()) {
            return 'N/A';
        } else {
            return string;
        }
    };
});

DropinFinder.filter('capitalize', function() {
    return function(input, all) {
        return (!!input) ? input.replace(/([^\W_]+[^\s-]*) */g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();}) : '';
    }
});


