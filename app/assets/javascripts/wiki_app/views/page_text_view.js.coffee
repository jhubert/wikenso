class WikiApp.Views.PageTextView extends Backbone.View
  el: ".wiki-pages-view-single-text"

  shortcuts:
    '⌘+b': "toggleBoldForSelection"
    'ctrl+b': "toggleBoldForSelection"
    '⌘+i': "toggleItalicForSelection"
    'ctrl+i': "toggleItalicForSelection"
    '⌘+k': "showAddLinkDialog"
    'ctrl+k': "showAddLinkDialog"

  events:
    "keyup": "updateText"

  initialize: (@model) =>
    @updateText(silent: true)
    _.extend(this, new Backbone.Shortcuts)
    @delegateShortcuts()
    @refreshLinkView()

  updateText: (options) =>
    @model.set('text', @getText(), options)

  getText: =>
    this.$el.find("p:empty").remove()
    this.$el.html().trim()

  refreshLinkView: =>
    @linkView.tearDown() if @linkView
    @linkView = new WikiApp.Views.LinkView

  focus: =>
    this.$el.focus()

  toggleBoldForSelection: => document.execCommand('bold', false, null)
  toggleItalicForSelection: => document.execCommand('italic', false, null)
  addLinkForSelection: (link) => document.execCommand('CreateLink', false, link)

  showAddLinkDialog: =>
    selection = rangy.getSelection()
    addLinkView = new WikiApp.Views.AddLinkView
    addLinkView.show()

    addLinkView.on("link:added", (link) =>
      rangy.restore(selection)
      @addLinkForSelection(link)
      @refreshLinkView()
    )