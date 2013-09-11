# Declare app level module which depends on filters, and services
angular
  .module("ocarinaMobile", [
    "ocarinaServices",
    "ocarinaFilters",
    "ocarinaDirectives",
    "ngRoute",
    "snap"])
  .config ["$locationProvider", "$routeProvider",
    ($locationProvider, $routeProvider) ->
      $locationProvider.html5Mode true

      $routeProvider.when "/",
        templateUrl: "angular/index/home"

      $routeProvider.when "/playlists/new",
        templateUrl: "angular/playlists/new"

      $routeProvider.when "/playlists/:playlistId",
        templateUrl: "angular/playlists/show"

      $routeProvider.otherwise redirectTo: "/"
]
