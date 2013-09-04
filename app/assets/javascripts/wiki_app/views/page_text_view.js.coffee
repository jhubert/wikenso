class WikiApp.Views.PageTextView extends Backbone.View
  el: ".wiki-pages-view-single-text"

  shortcuts:
    '⌘+b': "toggleBoldForSelection"
    'ctrl+b': "toggleBoldForSelection"
    '⌘+i': "toggleItalicForSelection"
    'ctrl+i': "toggleItalicForSelection"
    '⌘+k': "showAddLinkDialog"
    'ctrl+k': "showAddLinkDialog"
    '⌘+shift+.': "addHeadingForSelection"
    'ctrl+shift+.': "addHeadingForSelection"
    '⌘+shift+,': "removeHeadingForSelection"
    'ctrl+shift+,': "removeHeadingForSelection"

  events:
    "keyup": "updateText"
    "blur": "showPlaceholderIfTextEmpty"
    "focus": "removePlaceholder"

  initialize: (@model) =>
    @updateText(silent: true)
    _.extend(this, new Backbone.Shortcuts)
    _.extend(this, WikiApp.Concerns.Placeholder)
    @delegateShortcuts()
    @refreshLinkView()
    @setupFormatting()

  setupFormatting: =>
    @formattingView = new WikiApp.Views.FormattingView
    this.$el.on("mouseup", @showFormattingTooltip)
    this.$el.on("keyup", @showFormattingTooltip)
    @formattingView.on("formatting:link", @showAddLinkDialog)
    @formattingView.on("formatting:bold", @toggleBoldForSelection)
    @formattingView.on("formatting:italic", @toggleItalicForSelection)

  updateText: (options) =>
    @model.set('text', @getText(), options)

  showFormattingTooltip: =>
    if @isSelectionEmpty()
      @formattingView.hide()
    else if @hasSelectionChanged()
      @formattingView.showFormattingElementsForSelection(rangy.getSelection())

  getText: =>
    this.$el.find("p:empty").remove()
    this.$el.html().trim()

  refreshLinkView: =>
    @linkView.tearDown() if @linkView
    @linkView = new WikiApp.Views.LinkView

  focus: =>
    this.$el.focus()

  toggleBoldForSelection: (event) =>
    document.execCommand('bold', false, null)
    event.preventDefault()
    @updateText()

  toggleItalicForSelection: (event) =>
    document.execCommand('italic', false, null)
    event.preventDefault()
    @updateText()

  addLinkForSelection: (link) =>
    document.execCommand('CreateLink', false, link)
    @updateText()

  addHeadingForSelection: =>
    document.execCommand('formatBlock', false, "<h2>")
    @updateText()

  removeHeadingForSelection: =>
    document.execCommand('formatBlock', false, "<p>")
    @updateText()

  showAddLinkDialog: (event) =>
    event.preventDefault()
    selection = rangy.saveSelection()
    existingLink = $(rangy.getSelection().anchorNode).parent().attr("href")
    addLinkView = new WikiApp.Views.AddLinkView(existingLink: existingLink)
    addLinkView.show()

    addLinkView.on("link:added", (link) =>
      rangy.restoreSelection(selection)
      @addLinkForSelection(link) if link
      @refreshLinkView()
    )

  hasSelectionChanged: () =>
    oldSelection = @selection
    @selection = rangy.getSelection().toString()
    oldSelection != @selection

  isSelectionEmpty: =>
    rangy.getSelection().isCollapsed