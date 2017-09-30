# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class Preview
  constructor: (element) ->
    @element = $(element)
    @titleField = @element.find("[data-behavior='title-content']")
    @titlePreview = @element.find("[data-behavior='title-preview']")
    @bodyField = @element.find("[data-behavior='body-content']")
    @bodyPreview = @element.find("[data-behavior='body-preview']")
    @setEvents()

  setEvents: ->
    @titleField.on "focusout", @handlePreview
    @titleField.on "change", @handlePreview
    @titleField.on "keyup", @handlePreview
    @bodyField.on "focusout", @handlePreview
    @bodyField.on "change", @handlePreview
    @bodyField.on "keyup", @handlePreview

  handlePreview: =>
    titleHtml = marked @titleField.val()
    bodyHtml = marked @bodyField.val()
    document.getElementById('title-preview').innerHTML = titleHtml;
    document.getElementById('body-preview').innerHTML = bodyHtml;

jQuery ->
  $.each $("[data-behavior='wiki-form']"), (i, element)->
    new Preview(element)
