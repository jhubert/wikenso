#= require spec_helper

describe "PageModel", ->
  server = clock = model = null

  beforeEach ->
    server = sinon.fakeServer.create()
    model = new WikiApp.Models.PageModel
    clock = sinon.useFakeTimers()

  after =>
    server.restore()
    clock.restore()

  describe "auto save", =>
    it "saves the model 800ms after a change", ->
      spy = sinon.spy()
      model.setAutoSaveCallbacks({ request: spy })
      model.set("title", "Foo")
      clock.tick(801)
      spy.callCount.should.equal 1

    it "resets the timer after every change", ->
      spy = sinon.spy()
      model.setAutoSaveCallbacks({ request: spy })
      model.set("title", "Foo")
      clock.tick(500)
      model.set("title", "Foo123")
      clock.tick(801)
      spy.callCount.should.equal 1

    it "sends updates twice if a change is made while a save is happening", =>
      spy = sinon.spy()
      model.setAutoSaveCallbacks({ request: spy })
      model.set("title", "Foo")
      clock.tick(801)
      model.set("title", "FooBar")
      clock.tick(801)
      spy.callCount.should.equal 2

    it "optionally accepts arguments which it passes to Backbone.save", =>
      model.setAutoSaveCallbacks({})
      spy = sinon.spy(model, 'save')
      args = { wait: true }
      spy.withArgs({}, args)
      model.autoSave(args)
      spy.withArgs({}, args).callCount.should.equal 1

  describe "callbacks", =>
    describe "when the server responds with a success", =>

      beforeEach => server.respondWith([200, { "Content-Type": "application/json" }, '{ "body": "OK" }'])

      it "calls the success callback", =>
        spy = sinon.spy()
        model.setAutoSaveCallbacks({ success: spy })
        model.autoSave()
        server.respond()
        spy.callCount.should.equal 1

      it "calls the request callback", =>
        spy = sinon.spy()
        model.setAutoSaveCallbacks({ request: spy })
        model.autoSave()
        server.respond()
        spy.callCount.should.equal 1

      it "doesn't call the error callback", =>
        spy = sinon.spy()
        model.setAutoSaveCallbacks({ error: spy })
        model.autoSave()
        server.respond()
        spy.callCount.should.equal 0

    describe "when the server responds with an error", =>

      beforeEach => server.respondWith([400, { "Content-Type": "application/json" }, '{ "body": "BadRequest" }'])

      it "doesn't call the success callback", =>
        spy = sinon.spy()
        model.setAutoSaveCallbacks({ success: spy })
        model.autoSave()
        server.respond()
        spy.callCount.should.equal 0

      it "calls the request callback", =>
        spy = sinon.spy()
        model.setAutoSaveCallbacks({ request: spy })
        model.autoSave()
        server.respond()
        spy.callCount.should.equal 1

      it "calls the error callback", =>
        spy = sinon.spy()
        model.setAutoSaveCallbacks({ error: spy })
        model.autoSave()
        server.respond()
        spy.callCount.should.equal 1