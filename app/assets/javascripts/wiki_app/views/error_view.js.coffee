class WikiApp.Views.ErrorView extends Backbone.View
  el: ".error-text"

  show: (text) =>
    this.$el.text(text || "An error has occured.")
    this.$el.show('slow')

  hide: =>
    this.$el.hide('fast')