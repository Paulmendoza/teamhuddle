(function(angular) {
	"use strict";
	
	angular.module("TeamHuddle")
		.controller("ContactController", contactController);
		
	function contactController($log, $http) {
		var vm = this;
		
		vm.submitted  = false;
		vm.success    = false;
		vm.processing = false;
		
		vm.submit = submit;
		
		function submit() {
        	if (vm.processing) return;
			
			vm.submitted = true;
        	vm.processing = true;
			
	        $http.post('contact_us', vm.form_data).
	            success(function (data, status, headers, config) {
	                vm.success = true;
	                vm.processing = false;
	                vm.data = data;
	            }).
	            error(function (data, status, headers, config) {
	                vm.success = false;
	                vm.processing = false;
	                vm.data = data;
	            });
		}
	}
	
	contactController.$inject = ['$log', '$http'];
})(angular);
