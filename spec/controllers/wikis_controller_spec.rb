require 'spec_helper'

describe WikisController do
  describe "GET 'new'" do
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

  describe "GET 'create'" do
    context "when save is successful" do
      it "creates a new wiki" do
        expect { get 'create', :wiki => FactoryGirl.attributes_for(:wiki) }.to change { Wiki.count }.by(1)
      end

      it "creates a wiki with the supplied name" do
        get 'create', :wiki => FactoryGirl.attributes_for(:wiki, name: "FooWiki")
        Wiki.last.name.should == "FooWiki"
      end

      it "redirects to the subdomain for the wiki" do
        get 'create', :wiki => FactoryGirl.attributes_for(:wiki, name: "foowiki")
        response.should redirect_to "http://foowiki.test.host/"
      end
    end

    context "when save is unsuccessful due to a duplicate wiki name" do
      before(:each) { FactoryGirl.create(:wiki, name: "Foo") }

      it "doesn't create a new wiki" do
        expect { get 'create', :wiki => FactoryGirl.attributes_for(:wiki, name: "Foo") }.not_to change { Wiki.count }
      end

      it "renders the 'new' template" do
        get 'create', :wiki => FactoryGirl.attributes_for(:wiki, name: "Foo")
        response.should render_template(:new)
      end
    end

    context "when the params don't contain a key named 'wiki'" do
      it "raises an error" do
        expect { get 'create' }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "GET 'show'" do
    before(:each) { DatabaseCleaner.clean }
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
