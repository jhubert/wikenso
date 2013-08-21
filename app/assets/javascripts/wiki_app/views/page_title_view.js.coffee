class WikiApp.Views.PageTitleView extends Backbone.View
  el: ".wiki-pages-view-single-title"

  events:
    "keyup": "updateTitle"

  initialize: (@model) =>
    @model.set('title', @title.getTitle())

  setContentEditable: =>
    this.$el.attr('contenteditable', true)

  unsetContentEditable: =>
    this.$el.attr('contenteditable', false)

  updateTitle: =>
    @model.set('title', @getTitle())

  getTitle: =>
    this.$el.text().trim()