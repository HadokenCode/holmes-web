(function() {
  'use strict';
  var availableViolations;

  availableViolations = [
    {
      url: "g1.globo.com/politica/noticia/2013/09/tse-confirma-criacao-do-pros-31-partido-do-pais.html",
      text: "Too many requests. This page performs 2,450 requests and that takes its toll in the overall performance of the page.",
      page: 1,
      id: 1
    }, {
      url: "g1.globo.com",
      text: "No sitemap could be found for this domain. Having a sitemap is important because of reason.",
      page: 2,
      id: 2
    }, {
      url: "globo.com",
      text: "No opengraph metadata found for this page. This can hurt social sharing because it makes it harder for the social networks to understand what this page is about.",
      page: 3,
      id: 3
    }, {
      url: "ego.globo.com",
      text: "Total request size too big. This page loads 5mb of html, javascript, stylesheets and images. In a slower connection this will definitely hurt the overall user experience.",
      page: 4,
      id: 4
    }, {
      url: "ego.globo.com/paparazzo/noticia/2013/09/angelis-sobre-caio-castro-estava-ha-dois-anos-sem-ficar-com-um-homem.html",
      text: "No keywords metadata found. This may decrease search engines' ability to understand the topics of interest in this page.",
      page: 5,
      id: 5
    }
  ];

  angular.module('holmesApp').controller('MainCtrl', function($scope, $timeout, growl, $resource, $http, Restangular) {
    var addViolation;
    $http.defaults.useXDomain = true;
    $scope.clearForm = function() {
      $scope.model = {
        url: '',
        turnsOut: '',
        invalidUrl: ''
      };
      if ($scope.addPageForm) {
        return $scope.addPageForm.url.$pristine = true;
      }
    };
    $scope.clearForm();
    $scope.addPage = function() {
      var page, pages, url;
      url = $scope.model.url;
      $scope.model.turnsOut = '';
      $scope.model.invalidUrl = '';
      pages = Restangular.all('page');
      return page = pages.post({
        url: url
      }).then(function(page) {
        $scope.clearForm();
        return growl.addSuccessMessage(url + ' successfully saved!');
      }, function(response) {
        if (response.status === 400) {
          if (response.data.reason === 'invalid_url') {
            $scope.model.invalidUrl = response.data.url;
          }
          if (response.data.reason === 'redirect') {
            return $scope.model.turnsOut = response.data.effectiveUrl;
          }
        }
      });
    };
    $scope.violations = [];
    addViolation = function() {
      var item;
      jQuery("time.timeago").timeago();
      item = angular.copy(availableViolations[Math.floor(Math.random() * availableViolations.length)]);
      item.added = new Date().toISOString();
      item.addedString = jQuery.timeago(item.added);
      $scope.violations.splice(0, 0, item);
      $scope.violations = $scope.violations.slice(0, 12);
      return $timeout(addViolation, Math.floor(Math.random() * 30000));
    };
    return addViolation();
  });

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/