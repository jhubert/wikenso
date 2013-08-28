class WikiApp.Views.ShadowFormView extends Backbone.View
  el: ".wiki-pages-view-single-shadow-form"

  initialize: (@model) =>
    @model.on('change', @render)

  render: =>
    this.$el.find(".wiki-pages-view-single-shadow-form-text-input").val(@model.get('text'))
    this.$el.find(".wiki-pages-view-single-shadow-form-title-input").val(@model.get('title'))

  submit: =>
    this.$el.submit()