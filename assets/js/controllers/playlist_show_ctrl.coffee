angular.module("ocarinaMobile").controller 'PlaylistShowCtrl', ['Playlist', '$scope', '$timeout', '$route', 'Pusher', 'Facebook',
  (Playlist, $scope, $timeout, $route, Pusher, Facebook) ->
    # TODO uncomment
    $scope.playlistId = $route.current.params.playlistId

    Playlist.get($scope.playlistId).then (p) =>
      $scope.playlist = p
      # $scope.joinPlaylist(p.id) unless p.private
      # TODO fix this error... currentUser hasn't loaded yet
      Playlist.getCurrentSong(p.id) unless p.owner_id == $scope.currentUser.id
    $scope.showAddSongs = false
    $scope.hideAddSongsModal = ->
      $scope.showAddSongs = false

    $scope.showAddSongsModal = ->
      $scope.showAddSongs = true

    $scope.joinPlaylist = (id, password) ->
      return if $scope.isMember($scope.currentUser.id)
      Playlist.join(id, password).then (res) =>
        if res.status == 201
          $scope.currentUser.playlists_as_guest.push(res.data)
          $scope.playlist.guests.push($scope.currentUser)
        else if $scope.playlist.private
          $scope.alert =
            type: "danger"
            msg: "Oh snap... wrong password! Try again."

    $scope.isMember = (id) ->
      return unless $scope.playlist
      return true if id == $scope.playlist.owner_id
      _.findWhere $scope.playlist.guests, { id: id }

    $scope.showVoters = (index) =>
      $('.voters-container').eq(index).children().toggle()

    $scope.upvoteSong = (song) ->
      return if song.current_user_vote_decision == 1
      Playlist.vote($scope.playlistId, song.id, "upvote")
      song.vote_count++
      song.current_user_vote_decision++

    $scope.downvoteSong = (song) ->
      return if song.current_user_vote_decision == -1
      Playlist.vote($scope.playlistId, song.id, "downvote")
      song.vote_count--
      song.current_user_vote_decision--

    $scope.fbSendDialogURL = Facebook.openMessageDialog($scope.playlistId)

    ##
    # add songs modal
    $scope.openAddSongsModal = ->
      $scope.shouldBeOpen = true
    $scope.closeAddSongsModal = ->
      $scope.shouldBeOpen = false
    $scope.modalOpts = { backdropFade:true, dialogFade:true }

    ##
    # loading spinner
    $scope.$on 'addingSongs', ->
      $scope.inProgress = true
    $scope.$on 'addedSongs', ->
      $scope.inProgress = false

    ##
    # realtime updates
    setupPlaylistListener = (playlistChannel) ->
      playlistChannel.bind 'new-playlist-songs', (data) ->
        return if data.user_id == $scope.currentUser.id
        _.each data.playlist_songs, (song) ->
          song.current_user_vote_decision = 0
          $scope.playlist.playlist_songs.push(song)
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'song-played', (data) ->
        return if data.user_id == $scope.currentUser.id
        playlist = $scope.playlist.playlist_songs
        song = _.findWhere(playlist, {id: data.song_id})
        $scope.playlist.playlist_songs = _.without(playlist, song)
        $scope.playlist.currentSong = song
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'new-vote', (data) ->
        return if data.user_id == $scope.currentUser.id
        song = _.findWhere($scope.playlist.playlist_songs, {id: data.song_id})
        if data.action == "upvote"
          song.vote_count++
        else
          song.vote_count--
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'skip-song', (data) ->
        return unless $scope.playlist.owner_id == $scope.currentUser.id
        $scope.$broadcast('skip-song', data)

      playlistChannel.bind 'new-guest', (data) ->
        return if data.guest.id == $scope.currentUser.id
        $scope.playlist.guests.push data.guest
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'playback-ended', (data) ->
        return if $scope.playlist.owner_id == $scope.currentUser.id
        $scope.playlist.currentSong = undefined
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'current-song-request', (data) ->
        return unless $scope.playlist.owner_id == $scope.currentUser.id
        Playlist.respondCurrentSong(data.playlist_id, $scope.playlist.currentSong)

      playlistChannel.bind 'current-song-response', (data) ->
        return if $scope.playlist.owner_id == $scope.currentUser.id
        $scope.playlist.currentSong = data.song
        $scope.$apply() unless $scope.$$phase

    ##
    # subscribe to pusher channels
    playlistChannel = Pusher.subscribe("playlist-#{$scope.playlistId}")
    setupPlaylistListener(playlistChannel)
]
