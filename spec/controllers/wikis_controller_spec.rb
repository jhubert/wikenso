require 'spec_helper'
require 'concerns/controller_authentication_spec'

describe WikisController do
  context "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "assigns a wiki" do
      get 'new'
      assigns(:wiki).should be_a Wiki
    end

    it "assigns a user belonging to the wiki" do
      get 'new'
      wiki = assigns(:wiki)
      wiki.users.should_not be_empty
    end
  end

  context "GET 'create'" do
    context "when save is successful" do
      let(:users_attributes) { {"0" => FactoryGirl.attributes_for(:user)} }

      it "creates a new wiki" do
        expect do
          get 'create', wiki: FactoryGirl.attributes_for(:wiki, :users_attributes)
        end.to change { Wiki.count }.by(1)
      end

      it "creates a new user" do
        expect do
          get 'create', wiki: FactoryGirl.attributes_for(:wiki, :users_attributes)
        end.to change { User.count }.by(1)
      end

      it "signs the new user in" do
        get 'create', wiki: FactoryGirl.attributes_for(:wiki, :users_attributes)
        user = User.last
        controller.current_user.should == user
      end

      it "creates a wiki with the supplied name" do
        get 'create', :wiki => FactoryGirl.attributes_for(:wiki, :users_attributes, name: "FooWiki")
        Wiki.last.name.should == "FooWiki"
      end

      it "redirects to the subdomain for the wiki" do
        get 'create', :wiki => FactoryGirl.attributes_for(:wiki, :users_attributes, name: "foowiki")
        response.should redirect_to "http://foowiki.test.host/"
      end
    end

    context "when save is unsuccessful due to a duplicate wiki name" do
      before(:each) { FactoryGirl.create(:wiki, name: "Foo") }

      it "doesn't create a new wiki" do
        expect { get 'create', :wiki => FactoryGirl.attributes_for(:wiki, :users_attributes, name: "Foo") }.not_to change { Wiki.count }
      end

      it "renders the 'new' template" do
        get 'create', :wiki => FactoryGirl.attributes_for(:wiki, :users_attributes, name: "Foo")
        response.should render_template(:new)
      end

      it "doesn't sign the user in" do
        get 'create', wiki: FactoryGirl.attributes_for(:wiki, :users_attributes, name: "Foo")
        controller.current_user.should be_nil
      end
    end

    context "when the params don't contain a key named 'wiki'" do
      it "raises an error" do
        expect { get 'create' }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  context "GET 'show'" do
    before(:each) { sign_in(FactoryGirl.create(:user)) }

    context "for a valid subdomain" do
      it "returns HTTP success" do
        FactoryGirl.create(:wiki, name: "nilenso")
        @request.host = "nilenso.wikenso.com"
        get "show"
        response.should be_success
      end

      it "assigns the wiki whose name is the same as the subdomain" do
        wiki = FactoryGirl.create(:wiki, name: "nilenso")
        @request.host = "nilenso.wikenso.com"
        get "show"
        assigns(:wiki).should == wiki
      end

      it "matches a subdomain even when it's case is different" do
        wiki = FactoryGirl.create(:wiki, name: "UPPERCASE")
        @request.host = "uppercase.wikenso.com"
        get "show"
        assigns(:wiki).should == wiki
      end

      context "when the user is not authenticated" do
        before(:each) { sign_out }

        it "redirects to the login page for the subdomain" do
          wiki = FactoryGirl.create(:wiki, name: "foo")
          @request.host = "foo.wikenso.com"
          get "show"
          response.should redirect_to "http://foo.wikenso.com/sessions/new"
        end
      end
    end

    context "for an invalid subdomain" do
      it "throws an error" do
        wiki = FactoryGirl.create(:wiki, name: "nilenso")
        @request.host = "c42.wikenso.com"
        expect { get "show" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
