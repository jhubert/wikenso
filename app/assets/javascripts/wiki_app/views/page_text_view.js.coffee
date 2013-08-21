class WikiApp.Views.PageTextView extends Backbone.View
  el: ".wiki-pages-view-single-text"

  events:
    "keyup": "updateText"

  initialize: (@model) => @updateText(silent: true)

  updateText: (options) =>
    @model.set('text', @getText(), options)

  getText: =>
    this.$el.html().trim()

  focus: =>
    this.$el.focus()