class WikiApp.Views.EditableWikiPageView extends Backbone.View
  el: ".wiki-pages-view-single.edit"

  makeNonEditable: (callback) =>
    $(".wiki-pages-view-single").animate(
      width: "75%",
      1000,
      =>
        this.$el.removeClass("edit")
        this.$el.addClass("display")
        callback()
    )