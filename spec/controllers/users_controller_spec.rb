require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do
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
      users = create_list(:user, 5, wiki: wiki)
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
end
