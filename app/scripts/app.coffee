'use strict'

app = angular.module('holmesApp', [
  'ngCookies',
  'ngSanitize',
  'ngRoute',
  'angularMoment',
  'restangular',
  'reconnectingWebSocket',
  'ngCookies',
  'googleplus'
])
  .config ($routeProvider, RestangularProvider, ConfigConst, GooglePlusProvider) ->
    $routeProvider
      .when '/',
        redirectTo: '/domains'
      .when '/domains',
        templateUrl: 'views/domains.html'
        controller: 'DomainsCtrl'
      .when '/domains/:domainName',
        templateUrl: 'views/domain.html'
        controller: 'DomainCtrl'
      .when '/page/:pageId/review/:reviewId',
        templateUrl: 'views/reviews.html'
        controller: 'ReviewsCtrl'
      .when '/violations/:violationKey',
        templateUrl: 'views/violation.html'
        controller: 'ViolationCtrl'
      .when '/status',
        redirectTo: '/status/workers'
      .when '/status/workers',
        templateUrl: 'views/workers.html'
        controller: 'WorkersCtrl'
      .when '/status/last-reviews',
        templateUrl: 'views/last-reviews.html'
        controller: 'LastReviewsCtrl'
      .when '/status/pipeline',
        templateUrl: 'views/review-pipeline.html'
        controller: 'ReviewPipelineCtrl'
      .when '/status/requests',
        templateUrl: 'views/last-requests.html'
        controller: 'LastRequestsCtrl'
      .when '/status/concurrent',
        templateUrl: 'views/concurrent.html'
        controller: 'ConcurrentCtrl'
      .otherwise
        redirectTo: '/'
    RestangularProvider.setBaseUrl(ConfigConst.baseUrl)
    GooglePlusProvider.init({
      clientId: '968129569472-1smbhidqeo3kpdj029cehmnp8qh808kv',
      apiKey: '68129569472-1smbhidqeo3kpdj029cehmnp8qh808kv.apps.googleusercontent.com',
      scopes: 'https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile'
    })

  .run(($rootScope, $window) ->
    $rootScope.$on('$viewContentLoaded', ->
      $window.scrollTo(0, 0)
    )
  )
