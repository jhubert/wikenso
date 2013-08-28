class WikiApp.Models.PageModel extends Backbone.Model
  urlRoot: "/api/v1/draft_pages"

  initialize: =>
    @on('change', _.debounce(@autoSave, 800))

  setAutoSaveCallbacks: (options) =>
    @successCallback = options.success || (->)
    @errorCallback = options.error || (->)
    @requestCallback = options.request || (->)

  handleSuccess: => @successCallback()

  handleError: (model, xhr, options) =>
    console.log("Error while saving the page.", model, xhr, options)
    @errorCallback()

  autoSave: =>
    @requestCallback()
    @save({}, success: @handleSuccess, error: @handleError)