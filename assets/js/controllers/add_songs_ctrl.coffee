angular.module("ocarinaMobile").controller 'AddSongsCtrl', ['$scope', '$location', '$route', 'Playlist',
  ($scope, $location, $route, Playlist) ->
    # $scope.playlistId = $route.current.params.playlistId

    # Playlist.get($scope.playlistId).then (p) =>
    #   $scope.playlist = p

      ##
      # add songs setup
      $scope.provider = "Soundcloud"

      $scope.selectedSongs =
        dropbox: []
        soundcloud: []

      $scope.songInPlaylist = (song) ->
        if $scope.provider == "Dropbox"
          _.findWhere($scope.playlist.playlist_songs, {song_id: song}) || _.findWhere($scope.playlist.played_playlist_songs, {song_id: song})
        else if $scope.provider == "Soundcloud"
          _.findWhere($scope.playlist.playlist_songs, {path: song.uri}) || _.findWhere($scope.playlist.played_playlist_songs, {path: song.uri})

      $scope.isSongSelected = (provider, song) ->
        _.any $scope.selectedSongs[provider], (selectedSong) ->
          selectedSong == song

      $scope.toggleSongSelected = (provider, song) ->
        return if $scope.songInPlaylist(song)
        if $scope.isSongSelected(provider, song)
          $scope.selectedSongs[provider] = _.without($scope.selectedSongs[provider], song)
        else
          $scope.selectedSongs[provider].push(song)

      $scope.addSelectedSongs = ->
        $scope.$emit("addingSongs")
        Playlist.addSongs($scope.playlistId, $scope.selectedSongs).then (res) =>
          $scope.$emit("addedSongs")
          _.each res.data, (song) ->
            song.current_user_vote_decision = 0
            $scope.playlist.playlist_songs.push(song)
          $location.path("/playlists/#{$scope.playlistId}")

      $scope.clearSelectedSongs = ->
        $scope.scFilter = undefined
        $scope.dbFilter = undefined
        $scope.scResults = []
        $scope.selectedSongs =
          dropbox: []
          soundcloud: []

      ##
      # soundcloud search
      $scope.scResults = []
      $scope.searchSc = (query) ->
        if query
          SC.get '/tracks',
            q: query
            order: "hotness"
            duration:
              to: 600000
            limit: 10
          , (tracks, error) ->
            if error
              $scope.searchSc(query)
            else
              $scope.scResults = tracks
              $scope.$apply()
        else
          $scope.scResults = []
]
