angular.module('ocarinaMobile').controller 'PlaylistNewCtrl', ['$scope', 'Playlist', '$location',
  ($scope, Playlist, $location) ->
    $scope.newPlaylist =
      settings:
        continuous_play: true

    $scope.showLocationInput = false
    $scope.getLocation = ->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition($scope.showPosition, $scope.turnOnLocationInput)
      else
        $scope.turnOnLocationInput()

    $scope.turnOnLocationInput = ->
      $scope.showLocationInput = true
      $scope.$apply() unless $scope.$$phase


    $scope.showPosition = (position) ->
      $scope.newPlaylist.venue =
        venue:
          latitude: position.coords.latitude
          longitude: position.coords.longitude

    $scope.createPlaylist = () ->
      playlist = new Playlist()
      playlist.name = $scope.newPlaylist.name
      playlist.venue = $scope.newPlaylist.venue
      playlist.location = $scope.newPlaylist.location
      if $scope.newPlaylist.password
        playlist.private = true
        playlist.password = $scope.newPlaylist.password
      playlist.create().then (res) =>
        $location.path("/playlists/#{res.data.id}")
        $scope.currentUser.playlists.push(res.data)

    $scope.getLocation()
]
