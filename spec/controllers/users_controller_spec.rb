require 'spec_helper'

describe UsersController do

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

    it "assigns all the users of the wiki" do
      wiki = create(:wiki, subdomain: "foo")
      @request.host = "foo.example.com"
      users = create_list(:active_user, 5, wiki: wiki)
      get :index
      assigns(:users).should =~ users
    end

    it 'assigns the wiki' do
      wiki = create(:wiki, subdomain: "foo")
      @request.host = "foo.example.com"
      get :index
      assigns(:wiki).should == wiki
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
    end
  end
end
