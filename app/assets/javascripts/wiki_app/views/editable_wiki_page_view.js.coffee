class WikiApp.Views.EditableWikiPageView extends Backbone.View
  el: ".wiki-pages-view-single.edit"

  events:
    "keyup .wiki-pages-view-single-text": "updateText"

  initialize: =>
    @model = new WikiApp.Models.PageModel
    @title = new WikiApp.Views.PageTitleView(@model)
    @text = new WikiApp.Views.PageTextView(@model)
    @setContentEditable()

    @savingIndicator = new WikiApp.Views.SavingIndicatorView
    @helpText = new WikiApp.Views.HelpTextView
    @errorView = new WikiApp.Views.ErrorView

    @model.set('id', @getId())
    @model.setAutoSaveCallbacks(
      success: _.sequence(@savingIndicator.saved, @errorView.hide)
      request: @savingIndicator.saving,
      error: => @errorView.show("An error has occured while saving the page. Please try again.")
    )
    @model.once("change", @helpText.hide)
    @helpText.show()

  getId: =>
    this.$el.data('id')

  setContentEditable: => _.sequence(@title.setContentEditable, @text.setContentEditable, @text.focus)(this)

  unsetContentEditable: => _.sequence(@title.unsetContentEditable, @text.unsetContentEditable)(this)

  tearDown: (callback) =>
    _.sequence(@unsetContentEditable, @savingIndicator.hide, @helpText.hide, @undelegateEvents)(this)
    this.$el.animate(
      width: "75%",
      1000,
      =>
        this.$el.addClass("display")
        this.$el.removeClass("edit")
        callback()
    )
