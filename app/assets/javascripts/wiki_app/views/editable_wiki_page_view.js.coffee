class WikiApp.Views.EditableWikiPageView extends Backbone.View
  el: ".wiki-pages-view-single.edit"

  events:
    "keyup .wiki-pages-view-single-title": "updateTitle"
    "keyup .wiki-pages-view-single-text": "updateText"

  initialize: =>
    @title = this.$el.find(".wiki-pages-view-single-title")
    @text = this.$el.find(".wiki-pages-view-single-text")
    @setContentEditable()
    @model = new WikiApp.Models.PageModel(text: @getText(), title: @getTitle())

  updateTitle: =>
    @model.set('title', @getTitle())

  updateText: =>
    @model.set('text', @getText())

  getTitle: =>
    @title.html().trim()

  getText: =>
    @text.html().trim()

  setContentEditable: =>
    @title.attr('contenteditable', true)
    @text.attr('contenteditable', true)

  unsetContentEditable: =>
    @title.attr('contenteditable', false)
    @text.attr('contenteditable', false)

  tearDown: (callback) =>
    @unsetContentEditable()
    this.$el.animate(
      width: "75%",
      1000,
      =>
        this.$el.addClass("display")
        this.$el.removeClass("edit")
        callback()
    )
    @undelegateEvents()