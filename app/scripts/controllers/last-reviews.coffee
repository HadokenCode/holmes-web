'use strict'

class LastReviewsCtrl
  constructor: (@scope, @LastReviewsFcty, @WebSocketFcty) ->
    @lastReviews = []

    @getLastReviews()

    @WebSocketFcty.on((message) =>
      @getLastReviews() if message.type == 'new-review'
    )

    @scope.$on '$destroy', @_cleanUp

  _cleanUp: =>
    @WebSocketFcty.clearHandlers()

  _fillReviews: (reviews) =>
    @lastReviews = reviews
    @loadedReviews = reviews.length

  _fillReviewsInLastHour: (reviews) =>
    @lastReviewsInLastHour = reviews
    @lastReviewsInLastHour.perHour = @lastReviewsInLastHour.count / @lastReviewsInLastHour.ellapsed

    @loadedReviewsInLastHour = true

  getLastReviews: ->
    @LastReviewsFcty.getLastReviews().then @_fillReviews, =>
      @loadedReviews = null

    @LastReviewsFcty.getReviewsInLastHour().then @_fillReviewsInLastHour, =>
      @loadedReviewsInLastHour = null


angular.module('holmesApp')
  .controller 'LastReviewsCtrl', ($scope, LastReviewsFcty, WebSocketFcty) ->
    $scope.model = new LastReviewsCtrl($scope, LastReviewsFcty, WebSocketFcty)
