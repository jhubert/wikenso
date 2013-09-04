WikiApp.Concerns.Placeholder = {
  showPlaceholderIfTextEmpty: ->
    if _.blank(this.$el.text())
      this.$el.addClass("placeholder")
      this.$el.text(this.$el.data("placeholder"))

  removePlaceholder: ->
    if this.$el.hasClass("placeholder")
      this.$el.removeClass("placeholder")
      this.$el.html("")
}