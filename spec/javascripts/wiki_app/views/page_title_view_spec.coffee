#= require spec_helper

describe "PageTitleView", ->
  beforeEach =>
    $('body').html(JST['templates/page_title_view'])
    @model = new WikiApp.Models.PageModel

  it "gets the title text out of the DOM", =>
    pageTextView = new WikiApp.Views.PageTitleView(@model)
    pageTextView.getTitle().should.equal "Foo"

  it "updates the model with text from the DOM on initialize", =>
    new WikiApp.Views.PageTitleView(@model)
    @model.get('title').should.equal "Foo"