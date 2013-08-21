class WikiApp.Views.HelpTextView extends Backbone.View
  el: ".help-text"

  show: =>
    this.$el.show('slow')

  hide: =>
    this.$el.hide('slow')