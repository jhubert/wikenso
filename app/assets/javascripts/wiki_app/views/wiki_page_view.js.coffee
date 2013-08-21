class WikiApp.Views.WikiPageView extends Backbone.View
  el: ".wiki-pages-view-single"

  events:
    "keyup .wiki-pages-view-single-text": "updateText"

  initialize: =>
    @model = new WikiApp.Models.PageModel
    @title = new WikiApp.Views.PageTitleView(@model)
    @text = new WikiApp.Views.PageTextView(@model)

    @savingIndicator = new WikiApp.Views.SavingIndicatorView
    @helpText = new WikiApp.Views.HelpTextView
    @errorView = new WikiApp.Views.ErrorView

    @model.set('id', @getId(), silent: true)
    @model.setAutoSaveCallbacks(
      success: _.sequence(@savingIndicator.saved, @errorView.hide)
      request: @savingIndicator.saving,
      error: => @errorView.show("An error has occured while saving the page. Please try again.")
    )
    @model.once("change", @helpText.hide)

  getId: =>
    this.$el.data('id')

  tearDown: (callback) =>
    _.sequence(@savingIndicator.hide, @helpText.hide, @undelegateEvents)(this)
    this.$el.animate(
      width: "75%",
      1000,
      =>
        this.$el.addClass("display")
        this.$el.removeClass("edit")
        callback()
    )
