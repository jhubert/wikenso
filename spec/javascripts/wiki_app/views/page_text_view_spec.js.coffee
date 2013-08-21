#= require spec_helper

describe "PageTextView", ->
  beforeEach =>
    $('body').html(JST['templates/page_text_view'])
    @model = new WikiApp.Models.PageModel

  it "gets the text HTML out of the DOM", =>
    pageTextView = new WikiApp.Views.PageTextView(@model)
    pageTextView.getText().should.equal "<p>Foo</p>"

  it "updates the model with text from the DOM on initialize", =>
    new WikiApp.Views.PageTextView(@model)
    @model.get('text').should.equal "<p>Foo</p>"