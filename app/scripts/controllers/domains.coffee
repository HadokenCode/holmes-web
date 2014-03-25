'use strict'

class DomainsCtrl
  constructor: (@scope, @DomainsFcty, @MostCommonViolationsFcty, @WebSocketFcty) ->
    @domainsVisible = false
    @groupsVisible = true
    @mostFrequentVisible = false

    @getDomainData()
    @getMostCommonViolations()

    @WebSocketFcty.clearHandlers()
    @WebSocketFcty.on (message) =>
      if message.type == 'new-page' or message.type == 'new-review'
        @getDomainData()

  _fillDomains: (@domainList) =>
    @domainList = _.sortBy(@domainList.reverse(), 'is_active').reverse()
    @domains = @domainList
    @spinnerDomains = @domainList.length

  _fillViolations: (mostCommonViolations) =>
    @mostFrequentViolations = mostCommonViolations[0..9]
    @leastFrequentViolations = mostCommonViolations[10..]
    @groupData = _.groupBy(mostCommonViolations, 'category')
    @spinnerViolations = mostCommonViolations.length

  toggleDomainVisibility: ->
    @domainsVisible = !@domainsVisible

  showGroups: ->
    @groupsVisible = true
    @mostFrequentVisible = false

  showMostFrequent: ->
    @groupsVisible = false
    @mostFrequentVisible = true

  getDomainData: ->
    @DomainsFcty.getDomains().then @_fillDomains, =>
      @spinnerDomains = null

  getMostCommonViolations: ->
    @MostCommonViolationsFcty.getMostCommonViolations().then @_fillViolations, =>
      @spinnerViolations = null


angular.module('holmesApp')
  .controller 'DomainsCtrl', ($scope, DomainsFcty, MostCommonViolationsFcty, WebSocketFcty) ->

    $scope.model = new DomainsCtrl($scope, DomainsFcty, MostCommonViolationsFcty, WebSocketFcty)
