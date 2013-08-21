#= require spec_helper

describe "PageTitleView", ->
  beforeEach =>
    $('body').html(JST['templates/page_title_view'])
    @model = new WikiApp.Models.PageModel

  it "gets the title text out of the DOM", =>
    pageTextView = new WikiApp.Views.PageTitleView(@model)
    pageTextView.getTitle().should.equal "Foo"

  describe "on initialize", =>
    it "updates the model with text from the DOM on initialize", =>
      new WikiApp.Views.PageTitleView(@model)
      @model.get('title').should.equal "Foo"

    it "doesn't trigger a 'change' event", =>
      spy = sinon.spy()
      @model.on('change', spy)
      new WikiApp.Views.PageTitleView(@model)
      spy.callCount.should.equal 0