ocarinaFilters = angular.module('ocarinaFilters', [])

ocarinaFilters.filter 'truncate', ->
  (input, chars, breakOnWord, mobileOnly) ->
    if mobileOnly
      return input if $(window).width() > 768
    return input  if isNaN(chars)
    return ""  if chars <= 0
    if input and input.length >= chars
      input = input.substring(0, chars)
      unless breakOnWord
        lastspace = input.lastIndexOf(" ")
        input = input.substr(0, lastspace)  if lastspace isnt -1
      else
        input = input.substr(0, input.length - 1)  while input.charAt(input.length - 1) is " "
      return input + "..."
    input
