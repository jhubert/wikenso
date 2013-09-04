require 'spec_helper'

describe ControllerAuthentication, type: :controller do
  controller(ActionController::Base) do
    include ControllerAuthentication

    before_filter :authenticate_user!

    def index
      render nothing: true
    end
  end

  it "signs a user in by saving the ID in a signed cookie" do
    user = create(:active_user)
    @controller.sign_in(user)
    cookies.signed[:user_id].should == user.id
  end

  it "signs a user in permanently by saving the ID in a permanent signed cookie" do
    user = create(:active_user)
    @controller.sign_in_permanently(user)
    cookies.permanent.signed[:user_id].should == user.id
  end

  context "while signing out" do
    it "it clears the signed cookie" do
      @controller.sign_in(create(:active_user))
      @controller.sign_out
      cookies.signed[:user_id].should be_nil
    end

    it "clears the permanent signed cookie" do
      @controller.sign_in_permanently(create(:active_user))
      @controller.sign_out
      cookies.permanent.signed[:user_id].should be_nil
    end
  end

  context "when finding the current user" do
    it "returns the user if there is one logged in" do
      user = create(:active_user)
      @controller.sign_in(user)
      @controller.current_user.should == user
    end

    it "returns nil if no user is logged in" do
      user = create(:active_user)
      @controller.current_user.should be_nil
    end
  end

  context "when checking if a user is logged in" do
    it "returns true if a signed `user_id` exists" do
      cookies.signed[:user_id] = 1
      @controller.user_signed_in?.should be_true
    end

    it "returns true if a permanent signed `user_id` exists" do
      cookies.permanent.signed[:user_id] = 1
      @controller.user_signed_in?.should be_true
    end

    it "returns false if a user isn't logged in" do
      @controller.user_signed_in?.should be_false
    end
  end

  context "when authenticating a user" do
    it 'returns http success when the user is logged in' do
      @controller.sign_in(create(:active_user))
      get :index
      response.should be_success
    end

    it "redirects to the sessions#new page for that wiki" do
      @request.host = "foo.wikenso.dev"
      get :index
      response.should redirect_to "http://foo.wikenso.dev/sessions/new"
    end
  end
end