# Declare app level module which depends on filters, and services
@ocarinaMobile = angular
  .module("ocarinaMobile", [
    "ocarinaServices",
    "ocarinaFilters",
    "ocarinaDirectives",
    "ngRoute"])
  .config ["$locationProvider", "$routeProvider",
    ($locationProvider, $routeProvider) ->
      $locationProvider.html5Mode true

      $routeProvider.when "/view1",
        templateUrl: "angular/sample/partial1"

      $routeProvider.when "/view2",
        templateUrl: "angular/sample/partial2"

      $routeProvider.otherwise redirectTo: "/view1"
]
