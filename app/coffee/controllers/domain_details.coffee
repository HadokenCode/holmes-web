'use strict'

angular.module('holmesApp')
  .controller 'DomainDetailsCtrl', ($scope, $routeParams, Restangular, WebSocket) ->

    isValidDate = (d) ->
      if (Object.prototype.toString.call(d) != "[object Date]")
        return false
      return !isNaN(d.getTime())

    $scope.getClass = (pageIndex) ->
      return 'active' if pageIndex == $scope.model.currentPage
      return '' unless pageIndex == $scope.model.currentPage

    $scope.model = {
      domainDetails: {
        name: $routeParams.domainName,
        url: '',
        pageCount: 0,
        numberofPages: 0
        violationCount: 0,
        violationPoints: 0
      },
      currentPage: 1,
      numberOfPages: 0,
      pages: []
    }

    updateDomainDetails = ->
      Restangular.one('domains', $routeParams.domainName).get().then((domainDetails) ->
        $scope.model.domainDetails = domainDetails
      )

    updateReviews = ->
      Restangular.one('domains', $routeParams.domainName).getList('reviews', {current_page: $scope.model.currentPage}).then((domainData) ->
        $scope.model.pageCount = domainData.pageCount
        $scope.model.numberOfPages = Math.ceil(domainData.pageCount / 10)
        $scope.model.pages = domainData.pages
        $scope.model.pagesWithoutReview = domainData.pagesWithoutReview
        $scope.model.pagesWithoutReviewCount = domainData.pagesWithoutReviewCount

        $scope.model.nextPages = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] if $scope.model.currentPage < 6

        $scope.model.prevPage = Math.max(1, $scope.model.currentPage - 5)
        $scope.model.nextPage = Math.max(6, Math.min($scope.model.numberOfPages, $scope.model.currentPage + 5))

        if $scope.model.currentPage >= 6
          $scope.model.nextPages = []

          for i in [$scope.model.currentPage - 4 .. $scope.model.currentPage + 4] by 1
            $scope.model.nextPages.push(i)
      )

    updateDomainDetails()
    updateReviews()

    WebSocket.on((message) ->
      if message.type == 'new-page' or message.type == 'new-review'
        updateDomainDetails()
        updateReviews()
    )

    $scope.goToReviewPage = (pageIndex) ->
      $scope.model.currentPage = pageIndex
      updateReviews()
