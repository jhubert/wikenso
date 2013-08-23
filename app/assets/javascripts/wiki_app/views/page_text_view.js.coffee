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
    $(document).on("mouseup", @showFormattingTooltip)
    this.$el.on("keyup", @showFormattingTooltip)
    @delegateShortcuts()
    @refreshLinkView()
    @setupFormatting()

  setupFormatting: =>
    @formattingView = new WikiApp.Views.FormattingView
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

  toggleItalicForSelection: (event) =>
    document.execCommand('italic', false, null)
    event.preventDefault()

  addLinkForSelection: (link) => document.execCommand('CreateLink', false, link)

  showAddLinkDialog: (event) =>
    event.preventDefault()
    selection = rangy.saveSelection()
    addLinkView = new WikiApp.Views.AddLinkView
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