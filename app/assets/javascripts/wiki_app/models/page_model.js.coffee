class WikiApp.Models.PageModel extends Backbone.Model
  urlRoot: "/api/v1/pages"

  initialize: =>
    @on('change', @setAutoSaveTimeout)

  setAutoSaveTimeout: =>
    clearTimeout(@autoSaveTimeout)
    @autoSaveTimeout = setTimeout(@autoSave, 800)

  setAutoSaveCallbacks: (options) =>
    @successCallback = options.success || (->)
    @errorCallback = options.error || (-> console.log "Error while saving the page.")
    @requestCallback = options.request || (->)

  autoSave: =>
    @requestCallback()
    @save({}, { success: @successCallback, error: @errorCallback })