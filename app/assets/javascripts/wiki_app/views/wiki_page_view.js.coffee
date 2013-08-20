class WikiApp.Views.WikiPageView extends Backbone.View
  el: ".wiki-pages-view-single.display"

  makeEditable: (callback) =>
    $(".wiki-pages-view-single").animate(
      width: "100%",
      1000,
      =>
        this.$el.removeClass("display")
        this.$el.addClass("edit")
        callback()
    )