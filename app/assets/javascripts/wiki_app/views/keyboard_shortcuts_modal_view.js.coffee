class WikiApp.Views.KeyboardShortcutsModalView extends Backbone.View
  el: "#keyboard-shortcuts-modal"

  initialize: =>
    key("shift+/", @show)

  show: =>
    unless $("*").is(":focus")
      this.$el.foundation("reveal", "open")