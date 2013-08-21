class WikiApp.Views.SavingIndicatorView extends Backbone.View
  el: ".saving-indicator"

  saving: =>
    this.$el.text("Saving…")
    this.$el.show()

  saved: =>
    this.$el.text("Saved!")

  hide: => this.$el.hide()