class WikiApp.Views.EditableWikiPageView extends Backbone.View
  el: ".wiki-pages-view-single.edit"

  events:
    "keyup .wiki-pages-view-single-text": "updateText"

  initialize: =>
    @model = new WikiApp.Models.PageModel
    @title = new WikiApp.Views.PageTitleView(@model)
    @text = this.$el.find(".wiki-pages-view-single-text")
    @setContentEditable()

    @savingIndicator = new WikiApp.Views.SavingIndicatorView
    @helpText = new WikiApp.Views.HelpTextView

    @model.set(text: @getText(), id: @getId())
    @model.setAutoSaveCallbacks(success: @savingIndicator.saved, request: @savingIndicator.saving)
    @model.once("change", @helpText.hide)
    @helpText.show()

  updateText: =>
    @model.set('text', @getText())

  getId: =>
    this.$el.data('id')

  getText: =>
    @text.html().trim()

  setContentEditable: =>
    @title.setContentEditable()
    @text.attr('contenteditable', true)
    @text.focus()

  unsetContentEditable: =>
    @title.unsetContentEditable()
    @text.attr('contenteditable', false)

  tearDown: (callback) =>
    @unsetContentEditable()
    @savingIndicator.hide()
    @helpText.hide()
    this.$el.animate(
      width: "75%",
      1000,
      =>
        this.$el.addClass("display")
        this.$el.removeClass("edit")
        callback()
    )
    @undelegateEvents()