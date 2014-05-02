'use strict'

angular.module('holmesApp')
  .directive('holmesfooter', () ->
    replace: true
    template: """
    <footer>
      <div class="container light-grey fs0">
        <p class="ib">holmes is a free open-source project and is composed of
          <a target="_blank" class="blue under-hover" href="http://github.com/heynemann/holmes-web/">holmes-web ({{ holmesWebVersion }})</a> and
          <a target="_blank" class="blue under-hover" href="http://github.com/heynemann/holmes-api/">holmes-api ({{ apiVersion ? apiVersion : 'unavailable' }})</a>.
        </p>
        <p class="ib pull-right login" ng-switch on="isFormVisible">
          <a ng-switch-when="false" class="blue under-hover" href="javascript:void(0);" ng-click="login()">Login</a>
          <a ng-switch-when="true" class="blue under-hover" href="javascript:void(0);" ng-click="logout()">Logout</a>
        </p>
        <p class="ib pull-right login" ng-switch on="wsOpened">
          <span class="ws-label">API Status:</span>
          <span ng-switch-when="true" class="ws-opened">Opened</span>
          <span ng-switch-when="false" class="ws-closed">Closed</span>
        </p>
        <p class="ib pull-right">
          Copyright <a target="_blank" class="blue under-hover" href="http://opensource.globo.com">globo.com</a> - MIT Licensed - 2013
        </p>
      </div>
    </footer>
    """
    restrict: 'E'
    controller: ($scope, $cookieStore, GooglePlus, APIVersionFcty, packageJson) ->
      reloadPage = ->
        window.location.reload(true)

      APIVersionFcty.getAPIVersion().then( (version) ->
        $scope.apiVersion = version
      )

      $scope.holmesWebVersion = packageJson.version

      $scope.isFormVisible = if $cookieStore.get('HOLMES_AUTH_TOKEN') then true else false

      $scope.logout = () ->
        $cookieStore.remove('HOLMES_AUTH_TOKEN')
        reloadPage()

      $scope.login = () ->
        GooglePlus.login().then((data) =>
          authResult = GooglePlus.getToken()
          $cookieStore.put('HOLMES_AUTH_TOKEN', authResult.access_token)
          reloadPage()
        , (err) ->
          $scope.logout()
        )

  )
