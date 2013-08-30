require 'spec_helper'

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
      let(:users_attributes) { {"0" => attributes_for(:active_user)} }

      it "creates a new wiki" do
        expect do
          get 'create', wiki: attributes_for(:wiki, :users_attributes)
        end.to change { Wiki.count }.by(1)
      end

      it "creates a new active user" do
        expect do
          get 'create', wiki: attributes_for(:wiki, :users_attributes)
        end.to change { ActiveUser.count }.by(1)
      end

      it "signs the new user in" do
        get 'create', wiki: attributes_for(:wiki, :users_attributes)
        user = User.last
        controller.current_user.should == user
      end

      it "creates a wiki with the supplied subdomain" do
        get 'create', :wiki => attributes_for(:wiki, :users_attributes, subdomain: "FooWiki")
        Wiki.last.subdomain.should == "FooWiki"
      end

      it "redirects to the subdomain for the wiki" do
        get 'create', :wiki => attributes_for(:wiki, :users_attributes, subdomain: "foowiki")
        response.should redirect_to "http://foowiki.test.host/"
      end
    end

    context "when save is unsuccessful due to a duplicate wiki name" do
      before(:each) { create(:wiki, subdomain: "Foo") }

      it "doesn't create a new wiki" do
        expect { get 'create', :wiki => attributes_for(:wiki, :users_attributes, subdomain: "Foo") }.not_to change { Wiki.count }
      end

      it "renders the 'new' template" do
        get 'create', :wiki => attributes_for(:wiki, :users_attributes, subdomain: "Foo")
        response.should render_template(:new)
      end

      it "doesn't sign the user in" do
        get 'create', wiki: attributes_for(:wiki, :users_attributes, subdomain: "Foo")
        controller.current_user.should be_nil
      end

      it "sets a flash error" do
        get 'create', wiki: attributes_for(:wiki, :users_attributes, subdomain: "Foo")
        flash[:error].should_not be_empty
      end
    end

    context "when the params don't contain a key named 'wiki'" do
      it "raises an error" do
        expect { get 'create' }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  context "GET 'edit'" do
    let!(:wiki) { create(:wiki, subdomain: "foo") }
    before(:each) { @request.host = "foo.example.com" }

    it "assigns the current wiki" do
      get :edit
      assigns(:wiki).should == wiki
    end
  end

  context "PUT 'update'" do
    let!(:wiki) { create(:wiki, subdomain: "foo") }
    before(:each) { @request.host = "foo.example.com" }

    context "when updation is successful" do
      it "updates the logo of the current wiki" do
        logo = fixture_file_upload("logo.png")
        put :update, wiki: {logo: logo}
        wiki.reload.logo.file.read.should == logo.read
      end

      it "updates the name of the current wiki" do
        logo = fixture_file_upload("logo.png")
        put :update, wiki: { name: "foo" }
        wiki.reload.name.should == "foo"
      end

      it "sets a flash notice" do
        logo = fixture_file_upload("logo.png")
        put :update, wiki: {logo: logo}
        flash[:notice].should_not be_empty
      end

      it "redirects to the root page" do
        logo = fixture_file_upload("logo.png")
        put :update, wiki: {logo: logo}
        response.should redirect_to root_path
      end
    end

    context "when the updation is unsuccessful" do
      before(:each) { Wiki.any_instance.stub(:update).and_return(false) }

      it "sets a flash error" do
        logo = fixture_file_upload("logo.png")
        put :update, wiki: {logo: logo}
        flash[:error].should_not be_empty
      end

      it "renders the 'edit' action" do
        logo = fixture_file_upload("logo.png")
        put :update, wiki: {logo: logo}
        response.should render_template :edit
      end

      it "assigns the wiki" do
        logo = fixture_file_upload("logo.png")
        put :update, wiki: {logo: logo}
        assigns(:wiki).should == wiki
      end
    end
  end
end
