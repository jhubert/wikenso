#= require spec_helper

describe "AddLinkView", ->
  beforeEach =>
    $('body').html(JST['templates/add_link_view'])
    $("#add-link-modal").hide()

  it "clears the input field before it is opened", =>
    $(".add-link-modal-input").val("FOO!")
    new WikiApp.Views.AddLinkView
    $(".add-link-modal-input").val().should.equal ""

  it "gets the text of the link from the input field", =>
    view = new WikiApp.Views.AddLinkView
    $(".add-link-modal-input").val("FOO!")
    view.getLinkText().should.equal "FOO!"

  describe "after adding the link", =>
    it "triggers an event", =>
      view = new WikiApp.Views.AddLinkView
      spy = sinon.spy()
      view.on("link:added", spy)
      view.linkAdded()
      spy.callCount.should.equal 1

    it "passes along the link text with the event", =>
      view = new WikiApp.Views.AddLinkView
      spy = sinon.spy()
      view.on("link:added", spy)
      $(".add-link-modal-input").val("FOO!")
      spy.withArgs("FOO!")
      view.linkAdded()
      spy.withArgs("FOO!").callCount.should.equal 1

    it "hides the modal", =>
      view = new WikiApp.Views.AddLinkView
      view.linkAdded()
      $("#add-link-modal").is(":hidden").should.be.true

  describe "when pressing enter while typing the link", =>
    it "adds the link to the page", =>
      view = new WikiApp.Views.AddLinkView
      spy = sinon.spy()
      view.on("link:added", spy)
      event = { keyCode: 13, preventDefault: sinon.stub() }

      view.handleEnterKeypress(event)
      spy.callCount.should.equal 1

    it "prevents the default event", =>
      view = new WikiApp.Views.AddLinkView
      spy = sinon.spy()
      event = { keyCode: 13, preventDefault: spy }

      view.handleEnterKeypress(event)
      spy.callCount.should.equal 1

    it "doesn't prevent the default event if any other key is pressed", =>
      view = new WikiApp.Views.AddLinkView
      spy = sinon.spy()
      event = { keyCode: 14, preventDefault: spy }

      view.handleEnterKeypress(event)
      spy.callCount.should.equal 0
