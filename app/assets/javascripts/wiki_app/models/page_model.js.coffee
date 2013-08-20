class WikiApp.Models.PageModel extends Backbone.Model
  urlRoot: "/api/v1/pages"

  initialize: =>
    @on('change', @autoSave)

  autoSave: =>
    clearTimeout(@autoSaveTimeout)
    @autoSaveTimeout = setTimeout(@save, 1000)
