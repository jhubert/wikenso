#= require spec_helper

describe "PageTextView", ->
  beforeEach =>
    $('body').html(JST['templates/page_text_view'])
    @model = new WikiApp.Models.DraftPageModel

  describe "text", =>
    it "gets the text HTML out of the DOM", =>
      pageTextView = new WikiApp.Views.PageTextView(@model)
      pageTextView.getText().should.equal "<p>Foo</p>"

    it "gets rid of all empty <p> tags in the text", =>
      $(".wiki-pages-view-single-text").html("<p></p><p>Foo</p><p></p>")
      pageTextView = new WikiApp.Views.PageTextView(@model)
      pageTextView.getText().should.equal "<p>Foo</p>"

  describe "on initialize", =>
    it "updates the model with text from the DOM", =>
      new WikiApp.Views.PageTextView(@model)
      @model.get('text').should.equal "<p>Foo</p>"

    it "doesn't trigger a 'change' event", =>
      spy = sinon.spy()
      @model.on('change', spy)
      new WikiApp.Views.PageTextView(@model)
      spy.callCount.should.equal 0

  describe "when adding a link", =>
    event = null
    beforeEach =>
      $("#add-link-modal").hide()
      event = document.createEvent("KeyboardEvent")

    it "brings up the modal dialog", =>
      view = new WikiApp.Views.PageTextView(@model)
      (-> $("#add-link-modal").is(":hidden")).should.change.
      from(true).to(false).
      when -> view.showAddLinkDialog(event)

    it "restores the selected text after the modal has been closed", =>
      view = new WikiApp.Views.PageTextView(@model)
      spy = sinon.spy(rangy, 'restoreSelection')

      view.showAddLinkDialog(event)
      $(".add-link-modal-done").click()
      spy.callCount.should.equal 1

    it "adds a link for the selection", =>
      view = new WikiApp.Views.PageTextView(@model)
      spy = sinon.spy(view, 'addLinkForSelection')

      view.showAddLinkDialog(event)
      $(".add-link-modal-done").click()
      spy.callCount.should.equal 1

    it "refreshses the link view", =>
      view = new WikiApp.Views.PageTextView(@model)
      spy = sinon.spy(view, 'refreshLinkView')

      view.showAddLinkDialog(event)
      $(".add-link-modal-done").click()
      spy.callCount.should.equal 1

  describe "text selection", =>
    it "checks if the selection has changed", =>
      view = new WikiApp.Views.PageTextView(@model)
      toStringStub = sinon.stub()
      sinon.stub(rangy, 'getSelection').returns(toStringStub)

      stub = sinon.stub(toStringStub, 'toString').returns("Foo")
      view.hasSelectionChanged().should.be.true
      stub.returns("Foo")
      view.hasSelectionChanged().should.be.false

  describe "placeholder text", =>
    describe "when adding", =>
      it "sets the placeholder text from a data-placeholder attribute", =>
        view = new WikiApp.Views.PageTextView(@model)
        $(".wiki-pages-view-single-text").text('')
        $(".wiki-pages-view-single-text").data('placeholder', 'this is placeholder')
        view.showPlaceholderIfTextEmpty()
        $(".wiki-pages-view-single-text").text().should.equal("this is placeholder")

      it "adds placeholder text if the text is empty", =>
        view = new WikiApp.Views.PageTextView(@model)
        $(".wiki-pages-view-single-text").text('')
        view.showPlaceholderIfTextEmpty()
        $(".wiki-pages-view-single-text").text().should.equal("placeholder text")

      it "doesn't add placeholder text if the text is not empty", =>
        view = new WikiApp.Views.PageTextView(@model)
        $(".wiki-pages-view-single-text").text('Foo!')
        view.showPlaceholderIfTextEmpty()
        $(".wiki-pages-view-single-text").text().should.equal("Foo!")

      it "sets a `placeholder` class on the element", =>
        view = new WikiApp.Views.PageTextView(@model)
        $(".wiki-pages-view-single-text").text('')
        view.showPlaceholderIfTextEmpty()
        $(".wiki-pages-view-single-text").should.have.class "placeholder"

    describe "when removing", =>
      it "removes the placeholder class", =>
        view = new WikiApp.Views.PageTextView(@model)
        $(".wiki-pages-view-single-text").addClass("placeholder")
        view.removePlaceholder()
        $(".wiki-pages-view-single-text").should.not.have.class("placeholder")

      it "clears the contents of the element", =>
        view = new WikiApp.Views.PageTextView(@model)
        $(".wiki-pages-view-single-text").addClass("placeholder")
        $(".wiki-pages-view-single-text").text("Foo123")
        view.removePlaceholder()
        $(".wiki-pages-view-single-text").text().should.equal ""

      it "doesn't clear the contents of the element if it doesn't have a placeholder class", =>
        view = new WikiApp.Views.PageTextView(@model)
        $(".wiki-pages-view-single-text").text("Foo123")
        view.removePlaceholder()
        $(".wiki-pages-view-single-text").text().should.equal "Foo123"

