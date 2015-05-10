app.controller('welcome', ['$scope', '$http', function ($scope, $http) {
    $scope.data = new Array();

    $http.get('admin/admin_stats.json').
        success(function (data, status, headers, config) {
            $scope.data.push(['Marc', data.marc_count]);
            $scope.data.push(['Jon', data.jon_count]);
            $scope.data.push(['Akos', data.akos_count]);
            $scope.data.push(['Paul', data.paul_count]);
            $scope.data.push(['Danny', data.danny_count]);
        }).
        error(function (data, status, headers, config) {
            alert('Failed: ' + reason);
        });

    $scope.chartConfig = {
        //This is not a highcharts object. It just looks a little like one!
        options: {
            //This is the Main Highcharts chart config. Any Highchart options are valid here.
            //will be ovverriden by values specified below.
            chart: {
                type: 'pie'
            },
            tooltip: {
                style: {
                    padding: 10,
                    fontWeight: 'bold'
                }
            }
        },

        //The below properties are watched separately for changes.

        //Series object (optional) - a list of series using normal highcharts series options.
        series: [{
            data: $scope.data
        }],
        //Title configuration (optional)
        title: {
            text: 'Sport Events Entered'
        },
        //Boolean to control showng loading status on chart (optional)
        //Could be a string if you want to show specific loading text.
        loading: false,
        //Configuration for the xAxis (optional). Currently only one x axis can be dynamically controlled.
        //properties currentMin and currentMax provied 2-way binding to the chart's maximimum and minimum
        xAxis: {
            currentMin: 0,
            currentMax: 20,
            title: {text: 'values'}
        },
        //Whether to use HighStocks instead of HighCharts (optional). Defaults to false.
        useHighStocks: false,
        //size (optional) if left out the chart will default to size of the div or something sensible.
        size: {
            width: 500,
            height: 300
        },
        //function (optional)
        func: function (chart) {
            //setup some logic for the chart
        }

    };
}]);