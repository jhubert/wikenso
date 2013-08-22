class WikiApp.Views.PageTextView extends Backbone.View
  el: ".wiki-pages-view-single-text"

  shortcuts:
    '⌘+b': "toggleBoldForSelection"
    'ctrl+b': "toggleBoldForSelection"
    '⌘+i': "toggleItalicForSelection"
    'ctrl+i': "toggleItalicForSelection"

  events:
    "keyup": "updateText"

  initialize: (@model) =>
    @updateText(silent: true)
    _.extend(this, new Backbone.Shortcuts)
    @delegateShortcuts()

  updateText: (options) =>
    @model.set('text', @getText(), options)

  getText: =>
    this.$el.find("p:empty").remove()
    this.$el.html().trim()

  focus: =>
    this.$el.focus()

  toggleBoldForSelection: => document.execCommand('bold', false, null)
  toggleItalicForSelection: => document.execCommand('italic', false, null)