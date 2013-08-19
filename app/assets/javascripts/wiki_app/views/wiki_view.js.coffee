class WikiApp.Views.WikiView extends Backbone.View
  el: ".wiki-pages-view"

  events:
    "click .edit-wiki-page-button": "makeEditable"
    "click .finish-edit-wiki-page-button": "makeNonEditable"

  initialize: =>
    @wiki_page_view = new WikiApp.Views.WikiPageView
    @editButton = this.$el.find(".edit-wiki-page-button")
    @backButton = this.$el.find(".finish-edit-wiki-page-button")
    @backButton.hide()


  makeEditable: =>
    $(".wiki-pages-view-index").fadeOut "fast", =>
      @wiki_page_view.makeEditable =>
        @editButton.hide()
        @backButton.show()


  makeNonEditable: =>
    @wiki_page_view.makeNonEditable =>
      $(".wiki-pages-view-index").fadeIn("fast")
      @editButton.show()
      @backButton.hide()