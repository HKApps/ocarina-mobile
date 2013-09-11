angular.module('ocarinaMobile').controller 'UserCtrl', ['User', '$http', '$scope',
  (User, $http, $scope) ->
    # User.getCurrentUser().then (u) =>
    User.get(1).then (u) =>
      $scope.currentUser = u

      $scope.currentUser.hasPlaylists = ->
        $scope.currentUser.playlists.length > 0

      $scope.currentUser.hasPlaylistsAsGuest = ->
        $scope.currentUser.playlists_as_guest.length > 0

      $scope.deferDropboxConnect = ->
        $http.post("/defer_dropbox_connect").then () =>
          $scope.currentUser.defer_dropbox_connect = true
]
