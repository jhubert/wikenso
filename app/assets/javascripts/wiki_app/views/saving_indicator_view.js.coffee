class WikiApp.Views.SavingIndicatorView extends Backbone.View
  el: ".saving-indicator"

  saving: =>
    clearInterval(@timeAgoInterval)
    this.$el.text("Saving…")
    this.$el.show()

  saved: =>
    @lastSaveTime = moment()
    @timeAgoInterval = setInterval(@setTimeAgoText, 5000)
    this.$el.text("Saved!")
    this.$el.show()

  setTimeAgoText: =>
    this.$el.text("Last saved #{@lastSaveTime.fromNow()}")
