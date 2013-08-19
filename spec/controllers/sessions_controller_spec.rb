require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "assigns a user" do
      get 'new'
      assigns(:user).should be_a User
    end
  end

  describe "GET 'create'" do
    before(:each) do
      @request.host = "foo.wikenso.dev"
      wiki = create(:wiki, name: "Foo")
      @user = create(:user, wiki: wiki, email: "a@example.com", password: "foo", password_confirmation: "foo")
    end

    context "when the credentials are correct" do
      it "signs the user in" do
        get 'create', user: {email: "a@example.com", password: "foo"}
        session[:user_id].should == @user.id
      end

      it "redirects to the root page of the subdomain" do
        get 'create', user: {email: "a@example.com", password: "foo"}
        response.should redirect_to "http://foo.wikenso.dev/"
      end
    end

    context "when the credentials are wrong" do
      it "doesn't sign the user in if the email is incorrect" do
        get 'create', user: {email: "wrong@example.com", password: "foo"}
        session[:user_id].should be_nil
      end

      it "doesn't sign the user in if the password is incorrect" do
        get 'create', user: {email: "a@example.com", password: "foo123"}
        session[:user_id].should be_nil
      end

      it "doesn't sign the user in if both the email and password are incorrect" do
        get 'create', user: {email: "wrong@example.com", password: "123foo"}
        session[:user_id].should be_nil
      end

      it "assigns a user with the same email" do
        get 'create', user: {email: "wrong@example.com", password: "foo"}
        assigns(:user).email.should == "wrong@example.com"
      end

      it "sets a flash error message" do
        get 'create', user: {email: "wrong@example.com", password: "foo"}
        flash[:error].should_not be_empty
      end

      it "renders the new template" do
        get 'create', user: {email: "wrong@example.com", password: "foo"}
        response.should render_template :new
      end
    end

  end

  describe "GET 'destroy'" do
    it "redirects to the root path for that subdomain" do
      create(:wiki, name: "Foo")
      user = create(:user)
      @controller.sign_in(user)
      @request.host = "foo.wikenso.com"
      delete 'destroy', :id => user.id
      response.should redirect_to "http://foo.wikenso.com/"
    end

    it "clears user ID from the session" do
      user = create(:user)
      @controller.sign_in(user)
      expect { delete 'destroy', :id => user.id }.to change { session[:user_id] }.from(user.id).to(nil)
    end
  end

end
