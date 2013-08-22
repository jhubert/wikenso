class WikiApp.Views.LinkView extends Backbone.View
  el: ".wiki-pages-view-single-text a"

  events:
    "mouseenter": "showTooltip"
    "mouseout": "hideTooltip"

  Opentip.styles.linkTooltip = {
    shadow: false,
    escapeContent: true,
    tipJoint: 'bottom',
    delay: 0,
    showEffect: false,
    hideEffect: false,
    hideDelay: 0,
    background: "black"
    className: "wiki-pages-view-single-text-link-tooltip"
    borderWidth: 0
    removeElementsOnHide: true
  }

  showTooltip: (event) =>
    link = $(event.target).closest('a')
    linkHref = link.attr("href")
    @tip = new Opentip(link, linkHref, style: 'linkTooltip', target: link)
    @tip.show()

  hideTooltip: =>
    @tip.hide()