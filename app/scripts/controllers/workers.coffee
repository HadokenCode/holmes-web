'use strict'

class WorkersCtrl
  constructor: (@scope) ->
    @activeWorkersPercentage = 0.8
    @activeWorkers = []
    @workerCount = 20

    for i in [1..16]
      @activeWorkers.push(
        id: i
        domain:
          name: 'g1.globo.com'
        url: 'http://mentakingup2muchspaceonthetrain.tumblr.com/'
        lastPing: '2014-02-16T18:42:50Z'
      )


angular.module('holmesApp')
  .controller 'WorkersCtrl', ($scope) ->
    $scope.model = new WorkersCtrl($scope)
