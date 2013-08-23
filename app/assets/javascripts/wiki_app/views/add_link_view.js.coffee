class WikiApp.Views.AddLinkView extends Backbone.View
  el: "#add-link-modal"

  events:
    "click .add-link-modal-done": "linkAdded"
    "click .add-link-modal-cancel": "hide"
    "keydown .add-link-modal-input": "handleEnterKeypress"

  initialize: (options = {}) =>
    @input = this.$el.find(".add-link-modal-input")
    @input.val(options.existingLink || '')

  show: =>
    this.$el.on("opened", => @input.focus())
    this.$el.on("closed", =>
      @undelegateEvents()
      @trigger("link:added")
    )
    this.$el.foundation("reveal", "open")

  hide: => this.$el.foundation('reveal', 'close')

  getLinkText: =>
    linkText = @input.val()
    linkText = "http://" + linkText unless linkText.match(/\:\/\//)
    linkText


  linkAdded: =>
    @trigger("link:added", @getLinkText())
    @hide()

  handleEnterKeypress: (event) =>
    if event.keyCode == 13
      @linkAdded()
      event.preventDefault()