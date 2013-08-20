class WikiApp.Models.PageModel extends Backbone.Model
  urlRoot: "/api/v1/pages"

  initialize: =>
    @on('change', @setAutoSaveTimeout)

  setAutoSaveTimeout: =>
    clearTimeout(@autoSaveTimeout)
    @autoSaveTimeout = setTimeout(@autoSave, 1000)

  setAutoSaveCallbacks: (options) =>
    @successCallback = options.success || (->)
    @errorCallback = options.error || (->)
    @requestCallback = options.request || (->)

  autoSave: =>
    @requestCallback()
    @save().done(@successCallback).fail(@errorCallback)