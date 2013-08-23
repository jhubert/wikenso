class WikiApp.Views.FormattingView extends Backbone.View
  tagName: "div"

  initialize: (target) =>
    this.$el.html(Mustache.render(SMT["pages/edit/formatting_tooltip"]()))

  Opentip.styles.formattingTooltip = {
    shadow: false,
    escapeContent: false,
    tipJoint: 'bottom',
    delay: 0,
    showEffect: false,
    hideEffect: false,
    hideDelay: 0,
    background: "white"
    borderWidth: 0
    removeElementsOnHide: true
    fixed: true
  }

  showTooltip: (target) =>
    @tip = new Opentip(target, this.$el.html(), style: 'formattingTooltip', target: true)
    @tip.show()

  hideTooltip: =>
    @tip.hide()
