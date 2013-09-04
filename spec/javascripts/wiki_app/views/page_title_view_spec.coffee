#= require spec_helper

describe "PageTitleView", ->
  beforeEach =>
    $('body').html(JST['templates/page_title_view'])
    @model = new WikiApp.Models.DraftPageModel

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

  describe "placeholder text", =>
    describe "when adding", =>
      it "sets the placeholder text from a data-placeholder attribute", =>
        view = new WikiApp.Views.PageTitleView(@model)
        $(".wiki-pages-view-single-title").text('')
        $(".wiki-pages-view-single-title").data('placeholder', 'this is placeholder')
        view.showPlaceholderIfTextEmpty()
        $(".wiki-pages-view-single-title").text().should.equal("this is placeholder")

      it "adds placeholder text if the text is empty", =>
        view = new WikiApp.Views.PageTitleView(@model)
        $(".wiki-pages-view-single-title").text('')
        view.showPlaceholderIfTextEmpty()
        $(".wiki-pages-view-single-title").text().should.equal("placeholder text")

      it "doesn't add placeholder text if the text is not empty", =>
        view = new WikiApp.Views.PageTitleView(@model)
        $(".wiki-pages-view-single-title").text('Foo!')
        view.showPlaceholderIfTextEmpty()
        $(".wiki-pages-view-single-title").text().should.equal("Foo!")

      it "sets a `placeholder` class on the element", =>
        view = new WikiApp.Views.PageTitleView(@model)
        $(".wiki-pages-view-single-title").text('')
        view.showPlaceholderIfTextEmpty()
        $(".wiki-pages-view-single-title").should.have.class "placeholder"

    describe "when removing", =>
      it "removes the placeholder class", =>
        view = new WikiApp.Views.PageTitleView(@model)
        $(".wiki-pages-view-single-title").addClass("placeholder")
        view.removePlaceholder()
        $(".wiki-pages-view-single-title").should.not.have.class("placeholder")

      it "clears the contents of the element", =>
        view = new WikiApp.Views.PageTitleView(@model)
        $(".wiki-pages-view-single-title").addClass("placeholder")
        $(".wiki-pages-view-single-title").text("Foo123")
        view.removePlaceholder()
        $(".wiki-pages-view-single-title").text().should.equal ""

      it "doesn't clear the contents of the element if it doesn't have a placeholder class", =>
        view = new WikiApp.Views.PageTitleView(@model)
        $(".wiki-pages-view-single-title").text("Foo123")
        view.removePlaceholder()
        $(".wiki-pages-view-single-title").text().should.equal "Foo123"