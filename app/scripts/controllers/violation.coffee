'use strict'

class ViolationCtrl
  constructor: (@scope, @violationKey, @ViolationFcty, @location) ->
    if @violationKey in ['blacklist.domains']
      @showDetails = true
    @pageFilter = null
    @pageSize = 10
    @violation = {}
    @hasReviews = false
    @ViolationFcty.getDomainViolations(@violationKey).then @_fillViolation, =>
      @loadedViolation = null
      @loadedDetails = null
      @loadedReviews = null
    @watchScope()

    @domainFilter = @location.search().domain_filter

  _fillReviews: (violation) =>
    @violation.reviews = violation.reviews
    @reviewsCount = violation.reviewsCount
    if violation.reviewsCount != 0 and not @hasReviews
      @hasReviews = true
    @loadedReviews = violation.reviews.length

  _fillDetails: (details) =>
    counts = _.pluck details, 'count'
    countSum = if counts.length > 0 then counts.reduce (a, b) -> a + b else 0
    if details.length > 7
      details[6..] = details[6..].reduce (detail1, detail2) ->
        count: detail1.count + detail2.count
        domain: 'others'
    @details = _.map(
      details
      (detail) ->
        label: detail.domain
        value: detail.count
        percentage: detail.count / this * 100
      countSum
    )
    @loadedDetails = details.length

  _fillViolation: (violation) =>
    @_fillDetails(violation.details) if violation.details?
    @domains = _.sortBy(violation.domains, 'count').reverse()
    max_value = if @domains.length > 0 then @domains[0].count else 0
    splitIndex = _.findIndex @domains, (domain) ->
      return domain.count < (0.12 * max_value)
    others = _.reduce @domains[splitIndex..], (others, domain) ->
      return {
        name: 'others'
        count: others.count + domain.count
      }
    @violation.domainsCount = @domains.length
    violation.domains = @domains[0..splitIndex - 1].concat(others) if others?
    @violation.domains = _.map(
      violation.domains
      (domain) -> {
        name: domain.name
        value: domain.count
        percentage: domain.count / this
      }
      max_value)
    @violation.label = violation.title
    @violation.description = violation.description
    @violation.category = violation.category
    @violation.pageCount = violation.total

    params = @_addFilters {}

    @loadedViolation = @violation.domains.length

  _updateReviews: (params, force=false) =>
    if 'current_page' of params or 'domain_filter' of params or force
      delete(@loadedReviews)
      @ViolationFcty.getViolations(@violationKey, params).then @_fillReviews, =>
        @loadedReviews = null

  _addFilters: (params) =>
    if @domainFilter == 'all domains'
      delete(params['domain_filter'])
      delete(params['page_filter'])
    else
      params['domain_filter'] = @domainFilter
      params['page_filter'] = @pageFilter
    return params

  onPageFilterChange: =>
    @currentPage = 1
    params = @_addFilters {}
    @_updateReviews(params)

  onDomainFilterChange: (newVal, oldVal) =>
    # FIXME: The follwing verification should not be necessary
    if newVal != oldVal
      @currentPage = 1
      @pageFilter = null
      params = @_addFilters {}
      @_updateReviews(params, newVal != oldVal)

  onPageChange: (currentPage, pageSize) =>
    if currentPage? and pageSize?
      @currentPage = currentPage
      pageSize = @pageSize if not pageSize
      params = @_addFilters {}
      params['page_size'] = pageSize
      params['current_page'] = currentPage
      @_updateReviews(params)

  watchScope: ->
    onPageFilterChange = $.debounce 500, => @onPageFilterChange()
    @scope.$watch('model.pageFilter', onPageFilterChange)
    @scope.$watch('model.domainFilter', @onDomainFilterChange)


angular.module('holmesApp')
  .controller 'ViolationCtrl', ($scope, $routeParams, ViolationFcty, $location) ->
    $scope.model = new ViolationCtrl($scope, $routeParams.violationKey, ViolationFcty, $location)
