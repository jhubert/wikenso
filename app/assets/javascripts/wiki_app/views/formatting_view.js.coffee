class WikiApp.Views.FormattingView extends Backbone.View
  el: ".wiki-pages-view-formatting"

  marginRight: 80
  marginBottom: 50

  showFormattingElementsForSelection: (selection) =>
    coords = selection._ranges[0].nativeRange.getBoundingClientRect()
    left = ((coords.left + (coords.right - coords.left) / 2) - @marginRight)
    top = $(document).scrollTop() + coords.top - @marginBottom
    this.$el.css("left", "#{left}px")
    this.$el.css("top", "#{top}px")
    this.$el.show()

  hide: =>
    this.$el.hide()