'use strict'

class DomainsFactory
  constructor: (@restangular) ->

  getDomains: ->
    @restangular.all('domains').getList()

  getDomainsDetails: ->
    @restangular.all('domains-details').getList()

  getDomainPageCount: (domain) ->
    @restangular.one('domains', domain.name).one('page-count').get()

  getDomainReviewCount: (domain) ->
    @restangular.one('domains', domain.name).one('review-count').get()

  getDomainViolationCount: (domain) ->
    @restangular.one('domains', domain.name).one('violation-count').get()

  getDomainErrorPercentage: (domain) ->
    @restangular.one('domains', domain.name).one('error-percentage').get()

  getDomainResponseTimeAvg: (domain) ->
    @restangular.one('domains', domain.name).one('response-time-avg').get()

  getDomainReviews: (domainName, params) ->
    @restangular.one('domains', domainName).one('reviews').get(params)

  getDomainData: (domainName) ->
    @restangular.one('domains', domainName).get()


angular.module('holmesApp')
  .factory 'DomainsFcty', (Restangular) ->
    return new DomainsFactory(Restangular)
