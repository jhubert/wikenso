class WikiApp.Models.PageModel extends Backbone.Model
  urlRoot: "/api/v1/pages"

  initialize: =>
    @on('change', @setAutoSaveTimeout)

  setAutoSaveTimeout: =>
    clearTimeout(@autoSaveTimeout)
    @autoSaveTimeout = setTimeout(@autoSave, 800)

  setAutoSaveCallbacks: (options) =>
    @successCallback = options.success || (->)
    @errorCallback = options.error || (->)
    @requestCallback = options.request || (->)

  autoSave: =>
    console.log @changed
    @requestCallback()
    @save().done(@successCallback).fail(@errorCallback)