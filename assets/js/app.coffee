##
# require files
#= require lib/tools/snap
#= require lib/tools/ratchet
#= require lib/tools/lodash
#= require lib/angular/angular
#= require lib/angular/angular-route
#= require lib/tools/angular-snap
#= require controllers
#= require services
#= require filters
#= require directives
#= require_self

# Declare app level module which depends on filters, and services
@ocarinaMobile = angular
  .module("ocarinaMobile", [
    "ocarinaServices",
    "ocarinaFilters",
    "ocarinaDirectives",
    "ngRoute",
    "snap"])
  .config ["$locationProvider", "$routeProvider",
    ($locationProvider, $routeProvider) ->
      $locationProvider.html5Mode true

      $routeProvider.when "/view1",
        templateUrl: "angular/sample/partial1"

      $routeProvider.when "/view2",
        templateUrl: "angular/sample/partial2"

      $routeProvider.otherwise redirectTo: "/view1"
]
