#= require spec_helper

describe "ShadowFormView", ->
  server = clock = model = null

  beforeEach =>
    server = sinon.fakeServer.create()
    $('body').html(JST['templates/shadow_form_view'])
    @model = new WikiApp.Models.DraftPageModel
    @model.setAutoSaveCallbacks({})

  it "updates the shadow form when the model's title changes", =>
    view = new WikiApp.Views.ShadowFormView(@model)
    @model.set('title', "Foo")
    $(".wiki-pages-view-single-shadow-form-title-input").val().should.equal "Foo"

  it "updates the shadow form when the model's text changes", =>
    view = new WikiApp.Views.ShadowFormView(@model)
    @model.set('text', "Bar")
    $(".wiki-pages-view-single-shadow-form-text-input").val().should.equal "Bar"