class WikiApp.Views.PageTitleView extends Backbone.View
  el: ".wiki-pages-view-single-title"

  events:
    "keyup": "updateTitle"
    "blur": "showPlaceholderIfTextEmpty"
    "focus": "removePlaceholder"

  initialize: (@model) =>
    @updateTitle(silent: true)
    _.extend(this, WikiApp.Concerns.Placeholder)
    @showPlaceholderIfTextEmpty()

  updateTitle: (options) =>
    @model.set('title', @getTitle(), options)

  getTitle: =>
    this.$el.text().trim()