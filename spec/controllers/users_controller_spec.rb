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
end
