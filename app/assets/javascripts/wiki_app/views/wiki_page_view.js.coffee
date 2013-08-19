class WikiApp.Views.WikiPageView extends Backbone.View
  el: ".wiki-pages-view-single"

  makeEditable: (callback) =>
    $(".wiki-pages-view-single").animate
      width: "100%"
    , 1000, callback

  makeNonEditable: (callback) =>
    $(".wiki-pages-view-single").animate
      width: "75%"
    , 1000, callback