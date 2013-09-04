class WikiApp.Views.FormattingView extends Backbone.View
  el: ".wiki-pages-view-formatting"

  events:
    "click .wiki-pages-view-formatting-bold": "triggerBold"
    "click .wiki-pages-view-formatting-italic": "triggerItalic"
    "click .wiki-pages-view-formatting-link": "triggerLink"
    "click .wiki-pages-view-formatting-heading": "triggerAddHeading"
    "click .wiki-pages-view-formatting-paragraph": "triggerRemoveHeading"

  marginRight: 120
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

  triggerBold: (event) => @trigger("formatting:bold", event)
  triggerItalic: (event) => @trigger("formatting:italic", event)
  triggerLink: (event) => @trigger("formatting:link", event)

  triggerAddHeading: (event) =>
    @trigger("formatting:add_heading", event)
    @hide()

  triggerRemoveHeading: (event) =>
    @trigger("formatting:remove_heading", event)
    @hide()