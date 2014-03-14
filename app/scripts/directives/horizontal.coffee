'use strict'

angular.module('holmesApp')
  .directive('horizontal', ($filter) ->
    template: '<div class="horizontal-bar"></div>'
    replace: true
    restrict: 'E'
    scope:
      percentage: '='
      value: '='
      total: '='
      showtotal: '='
      valuelabel: '@'
      totallabel: '@'
    link: (scope, element, attrs) ->
      showTotal = false
      showTotal = scope.showtotal if scope.showtotal?

      element.html('<div class="value"></div>')
      valueElement = element.find('.value')
      maxWidth = element.width()
      width = scope.percentage * maxWidth
      valueElement.css('width', width)
      valueLabelWidth = null
      totalLabelWidth = null

      setElementValue = (value) ->
        valueLabel = ''
        if scope.valuelabel?
          valueLabel = '<div class="value-label">' + scope.valuelabel + '</div>'

        valueElement.html($filter('number')(value) + valueLabel)
        valueLabelWidth = valueElement.find('.value-label').width()

      setElementValue(scope.value)

      totalLabel = null
      if scope.totallabel?
        totalLabel = angular.element('<div class="total-label">' + scope.totallabel + '</div>')
        element.append(totalLabel)
        totalLabelWidth = totalLabel.width()

      totalValueElement = null
      if showTotal
        total = $filter('number')(scope.total - scope.value)
        totalValueElement = angular.element('<div class="total">' + total + '</div>')
        element.append(totalValueElement)

      setElementTotalValue = (totalValue) ->
        totalValueElement.html(totalValue)

      if totalValueElement
        setElementTotalValue(scope.total)

      scope.$watch('value', (newValue, oldValue) ->
        setElementValue(newValue)
      )

      scope.$watch('total', (newValue, oldValue) ->
        if totalValueElement
          setElementTotalValue(newValue)
      )

      scope.$watch('percentage', (newValue, oldValue) ->
        idealdx = (Math.floor(Math.log(scope.value) / Math.log(1000))) * 0.012
        idealRatio = idealdx + (Math.floor(Math.log(scope.value) / Math.log(10)) + 1) * 0.024
        width = if scope.percentage > idealRatio then scope.percentage * maxWidth else idealRatio * maxWidth
        valueElement.css('width', width)

        if totalLabel?
          if width > maxWidth - totalLabelWidth
            totalLabel.fadeOut()
            totalValue.fadeOut() if totalValue?
          else
            totalLabel.fadeIn()
            totalValue.fadeIn() if totalValue?

        if scope.valuelabel?
          label = valueElement.find('.value-label')
          if width < label.width()
            label.fadeOut()
          else
            label.fadeIn()
      )
  )
