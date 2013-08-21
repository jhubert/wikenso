class WikiApp.Views.PageTextView extends Backbone.View
  el: ".wiki-pages-view-single-text"

  events:
    "keyup": "updateText"

  initialize: (@model) => @updateText()

  updateText: =>
    @model.set('text', @getText())

  getText: =>
    this.$el.html().trim()

  setContentEditable: =>
    this.$el.attr('contenteditable', true)

  unsetContentEditable: =>
    this.$el.attr('contenteditable', false)

  focus: =>
    this.$el.focus()