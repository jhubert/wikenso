class WikiApp.Views.WikiPageView extends Backbone.View
  el: ".wiki-pages-view-single.display"


  tearDown: (callback) =>
    this.$el.animate(
      width: "100%",
      1000,
      =>
        this.$el.addClass("edit")
        this.$el.removeClass("display")
        callback()
    )
    @undelegateEvents()