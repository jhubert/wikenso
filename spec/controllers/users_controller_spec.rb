require 'spec_helper'

describe UsersController do
  before(:each) { sign_in(create(:active_user)) }

  context "GET 'index'" do
    it "returns http success" do
      wiki = create(:wiki, subdomain: "foo")
      @request.host = "foo.example.com"
      get 'index'
      response.should be_success
    end

    it "raises an error if the subdomain is invalid" do
      @request.host = "invalid.example.com"
      expect { get :index }.to raise_error
    end

    it 'assigns the wiki' do
      wiki = create(:wiki, subdomain: "foo")
      @request.host = "foo.example.com"
      get :index
      assigns(:wiki).should == wiki
    end

    it "doesn't allow access if the user is not logged in" do
      session[:user_id] = nil
      get :index
      response.should redirect_to new_session_path
    end
  end

  context "POST 'create'" do
    let(:wiki) { create(:wiki, subdomain: "foo") }
    before(:each) { @request.host = "foo.example.com" }

    context "when the creation succeeds" do
      it "creates a pending user" do
        expect { post :create, user: attributes_for(:active_user, wiki: wiki) }.to change { PendingUser.count }.by(1)
      end

      it "doesn't create an active user" do
        expect { post :create, user: attributes_for(:active_user, wiki: wiki) }.not_to change { ActiveUser.count }
      end

      it "redirects to the users index page" do
        post :create, user: attributes_for(:active_user, wiki: wiki)
        response.should redirect_to users_path
      end

      it "creates a user belonging to the current wiki" do
        post :create, user: attributes_for(:active_user, wiki: wiki)
        User.last.wiki.should == wiki
      end

      it "creates an invitation for the user" do
        post :create, user: attributes_for(:active_user, wiki: wiki)
        User.last.invitations.should_not be_empty
      end
    end

    context "when the creation fails" do
      it "doesn't create a user" do
        user_attributes = attributes_for(:active_user, wiki: wiki, email: "thisisnotanemail")
        expect { post :create, user: user_attributes }.not_to change { User.count }
      end

      it "returns a 400" do
        user_attributes = attributes_for(:active_user, wiki: wiki, email: "thisisnotanemail")
        post :create, user: user_attributes
        response.status.should == 400
      end

      it "renders the 'index' template" do
        user_attributes = attributes_for(:active_user, wiki: wiki, email: "thisisnotanemail")
        post :create, user: user_attributes
        response.should render_template :index
      end

      it "assigns the wiki" do
        user_attributes = attributes_for(:active_user, wiki: wiki, email: "thisisnotanemail")
        post :create, user: user_attributes
        assigns(:wiki).should == wiki
      end

      it "sets the flash error" do
        user_attributes = attributes_for(:active_user, wiki: wiki, email: "thisisnotanemail")
        post :create, user: user_attributes
        flash[:error].should include "Email is invalid"
      end
    end

    it "doesn't allow access if the user is not logged in" do
      session[:user_id] = nil
      post :create, user: attributes_for(:active_user, wiki: wiki)
      response.should redirect_to new_session_path
    end
  end
end
