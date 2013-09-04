require 'spec_helper'

describe SessionsController do

  context "GET 'new'" do
    let!(:wiki) { create(:wiki, subdomain: "foo") }
    before(:each) { @request.host = "foo.example.com" }

    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "assigns a user" do
      get 'new'
      assigns(:user).should be_a User
    end

    it "assigns a user belonging to the current wiki" do
      get 'new'
      assigns(:user).wiki.should == wiki
    end
  end

  context "GET 'create'" do
    before(:each) do
      sign_out
      @request.host = "foo.wikenso.dev"
      @wiki = create(:wiki, subdomain: "Foo")
      @active_user = create(:active_user, wiki: @wiki, email: "a@example.com", password: "foo")
    end

    context "when the credentials are correct" do
      it "signs the user in if he is active" do
        get 'create', user: {email: "a@example.com", password: "foo", password_confirmation: "foo"}
        user_signed_in?.should be_true
      end

      it "doesn't sign the user in if he is pending" do
        pending_user = create(:pending_user, wiki: @wiki, email: "pending@example.com", password: "foo", password_confirmation: "foo")
        get 'create', user: {email: "pending@example.com", password: "foo", password_confirmation: "foo"}
        user_signed_in?.should be_false
      end

      it "redirects to the root page of the subdomain" do
        get 'create', user: {email: "a@example.com", password: "foo", password_confirmation: "foo"}
        response.should redirect_to "http://foo.wikenso.dev/"
      end
    end

    context "when the credentials are wrong" do
      it "doesn't sign the user in if the email is incorrect" do
        get 'create', user: {email: "wrong@example.com", password: "foo", password_confirmation: "foo"}
        user_signed_in?.should be_false
      end

      it "doesn't sign the user in if the password is incorrect" do
        get 'create', user: {email: "a@example.com", password: "foo123"}
        user_signed_in?.should be_false
      end

      it "doesn't sign the user in if both the email and password are incorrect" do
        get 'create', user: {email: "wrong@example.com", password: "123foo"}
        user_signed_in?.should be_false
      end

      it "assigns a user with the same email" do
        get 'create', user: {email: "wrong@example.com", password: "foo", password_confirmation: "foo"}
        assigns(:user).email.should == "wrong@example.com"
      end

      it "assigns a user belonging to the wiki" do
        get 'create', user: {email: "wrong@example.com", password: "foo", password_confirmation: "foo"}
        assigns(:user).wiki.should == @wiki
      end

      it "sets a flash error message" do
        get 'create', user: {email: "wrong@example.com", password: "foo", password_confirmation: "foo"}
        flash[:error].should_not be_empty
      end

      it "renders the new template" do
        get 'create', user: {email: "wrong@example.com", password: "foo", password_confirmation: "foo"}
        response.should render_template :new
      end
    end
  end

  context "GET 'destroy'" do
    it "redirects to the root path for that subdomain" do
      create(:wiki, subdomain: "Foo")
      user = create(:active_user)
      @controller.sign_in(user)
      @request.host = "foo.wikenso.com"
      delete 'destroy'
      response.should redirect_to "http://foo.wikenso.com/"
    end

    it "clears user ID from the session" do
      user = create(:active_user)
      @controller.sign_in(user)
      expect { delete 'destroy' }.to change { user_signed_in? }.from(true).to(false)
    end
  end

end
