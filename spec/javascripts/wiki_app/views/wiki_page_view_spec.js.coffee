#= require spec_helper

describe "WikiPageView", =>
  beforeEach =>
    $('body').html(JST['templates/wiki_page_view'])
    @model = new WikiApp.Models.PageModel

  it "gets the ID of the model from a `data` attribute set in the DOM", =>
    wikiPageView = new WikiApp.Views.WikiPageView(@model)
    wikiPageView.getId().should.equal 5

  describe "during initialization", =>
    it "sets the ID of the model", =>
      wikiPageView = new WikiApp.Views.WikiPageView(@model)
      @model.get('id').should.equal 5

    it "doesn't trigger a 'change' event", =>
      spy = sinon.spy()
      @model.on("change", spy)
      wikiPageView = new WikiApp.Views.WikiPageView(@model)
      @model.get('id').should.equal 5
      spy.callCount.should.equal 0

  it "hides the help text after the first model change", =>
    wikiPageView = new WikiApp.Views.WikiPageView(@model)
    (-> $(".help-text").is(":hidden")).should.change.
    from(false).to(true).
    when -> @model.set('title', "Foo123")

  describe "saving", =>
    server = sinon.fakeServer.create()
    after: -> server.restore()

    it "changes the text of the saving indicator to 'Saving… while the save is in progress", =>
      new WikiApp.Views.WikiPageView(@model)
      @model.autoSave()
      server.respond()
      $(".saving-indicator").should.have.text "Saving…"

    describe "when the response is a success", =>
      beforeEach => server.respondWith([200, { "Content-Type": "application/json" }, '{ "body": "OK" }'])

      it "changes the text of the saving indicator to 'Saved!'", =>
        new WikiApp.Views.WikiPageView(@model)
        @model.autoSave()
        server.respond()
        $(".saving-indicator").should.have.text "Saved!"

      it "hides the error view", =>
        new WikiApp.Views.WikiPageView(@model)
        @model.autoSave()
        server.respond()
        $(".error-text").should.be.hidden

    describe "when the response is an error", =>
      beforeEach => server.respondWith([400, { "Content-Type": "application/json" }, '{ "body": "Bad Request" }'])

      it "shows the error view", =>
        $(".error-text").hide()
        new WikiApp.Views.WikiPageView(@model)
        @model.autoSave()
        server.respond()
        $(".error-text").should.not.be.hidden