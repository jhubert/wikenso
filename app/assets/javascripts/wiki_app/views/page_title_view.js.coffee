class WikiApp.Views.PageTitleView extends Backbone.View
  el: ".wiki-pages-view-single-title"

  events:
    "keyup": "updateTitle"

  initialize: (@model) => @updateTitle(silent: true)

  updateTitle: (options) =>
    @model.set('title', @getTitle(), options)

  getTitle: =>
    this.$el.text().trim()