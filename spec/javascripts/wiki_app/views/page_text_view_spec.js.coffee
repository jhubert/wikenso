#= require spec_helper

describe "PageTextView", ->
  beforeEach =>
    $('body').html(JST['templates/page_text_view'])
    @model = new WikiApp.Models.PageModel

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
    beforeEach => $("#add-link-modal").hide()

    it "brings up the modal dialog", =>
      view = new WikiApp.Views.PageTextView(@model)
      (-> $("#add-link-modal").is(":hidden")).should.change.
      from(true).to(false).
      when -> view.showAddLinkDialog()

    it "restores the selected text after the modal has been closed", =>
      view = new WikiApp.Views.PageTextView(@model)

      selection = new WikiApp.DocumentSelection
      sinon.stub(view, 'getSelection').returns(selection)
      spy = sinon.spy(selection, 'restore')

      view.showAddLinkDialog()
      $(".add-link-modal-done").click()
      spy.callCount.should.equal 1

    it "adds a link for the selection", =>
      view = new WikiApp.Views.PageTextView(@model)
      spy = sinon.spy(view, 'addLinkForSelection')

      view.showAddLinkDialog()
      $(".add-link-modal-done").click()
      spy.callCount.should.equal 1