require 'spec_helper'

describe PagesController do
  before(:each) { sign_in(create(:active_user)) }

  context "GET 'edit'" do
    let(:wiki) { create(:wiki, subdomain: "foo") }
    before(:each) { @request.host = "foo.example.com" }

    it "raises an error if the ID is invalid" do
      expect { get :edit, id: 1234 }.to raise_error
    end

    it "raises an error if the ID points to a page belonging to another wiki" do
      page = create(:page, wiki: create(:wiki))
      expect { get :edit, id: page.id }.to raise_error
    end

    it "creates a draft page if one does't exist" do
      page = create(:page, wiki: wiki, title: "foo")
      expect { get :edit, id: "foo" }.to change { page.draft_pages.count }.from(0).to(1)
    end

    it "assigns the page" do
      page = create(:page, wiki: wiki, title: "foo")
      get :edit, id: "foo"
      assigns(:page).should == page
    end

    it "assigns the created draft page" do
      page = create(:page, wiki: wiki, title: "foo")
      get :edit, id: "foo"
      assigns(:draft_page).should be_a DraftPage
    end
  end

  context "GET 'show'" do
    context "for a valid subdomain" do
      it "returns HTTP success" do
        create(:wiki, :single_page, subdomain: "nilenso")
        @request.host = "nilenso.wikenso.com"
        get "show"
        response.should be_success
      end

      it "assigns the wiki whose subdomain is the same as the request subdomain" do
        wiki = create(:wiki, :single_page, subdomain: "nilenso")
        @request.host = "nilenso.wikenso.com"
        get "show"
        assigns(:wiki).should == wiki
      end

      it "matches a subdomain even when it's case is different" do
        wiki = create(:wiki, :single_page, subdomain: "UPPERCASE")
        @request.host = "uppercase.wikenso.com"
        get "show"
        assigns(:wiki).should == wiki
      end

      context "when assigning the page" do
        let(:wiki) { create(:wiki, subdomain: "foo") }
        before(:each) { @request.host = "foo.wikenso.com" }

        it "assigns the page corresponding to the passed friendly ID" do
          page = create(:page, wiki: wiki, title: "foo")
          get :show, id: "foo"
          assigns(:page).should == page
        end

        it "assigns the first page if no ID is passed" do
          first_page = create(:page, wiki: wiki)
          second_page = create(:page, wiki: wiki)
          get :show
          assigns(:page).should == first_page
        end

        it "raises an error if an invalid ID is passed" do
          first_page = create(:page, wiki: wiki)
          second_page = create(:page, wiki: wiki)
          expect { get :show, id: 12345 }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when the user is not authenticated" do
        before(:each) { sign_out }

        it "redirects to the login page for the subdomain" do
          wiki = create(:wiki, subdomain: "foo")
          @request.host = "foo.wikenso.com"
          get "show"
          response.should redirect_to "http://foo.wikenso.com/sessions/new"
        end
      end
    end

    context "for an invalid subdomain" do
      it "throws a RoutingError (404)" do
        wiki = create(:wiki, subdomain: "nilenso")
        @request.host = "c42.wikenso.com"
        expect { get "show" }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  context "GET 'new'" do
    let!(:wiki) { create(:wiki, subdomain: "foo") }
    before(:each) { @request.host = "foo.example.com" }

    it "assigns a page" do
      get :new
      assigns(:page).should be_a Page
    end

    it "assigns a page belonging to the current wiki" do
      get :new
      assigns(:page).wiki.should == wiki
    end
  end

  context "POST 'create'" do
    let!(:wiki) { create(:wiki, subdomain: "foo") }
    before(:each) { @request.host = "foo.example.com" }

    context "when creation is successful" do
      it "creates a page" do
        page_params = attributes_for(:page)
        expect { post :create, page: page_params }.to change { Page.count }.by(1)
      end

      it "creates a page with the passed title" do
        page_params = attributes_for(:page, title: "Foo")
        post :create, page: page_params
        Page.last.title.should == "Foo"
      end

      it "creates a page belonging to the current wiki" do
        wiki = create(:wiki, subdomain: "bar")
        @request.host = "bar.example.com"
        post :create, page: attributes_for(:page, title: "Foo")
        Page.last.wiki.should == wiki
      end

      it "creates a page belonging to the current user" do
        user = create(:active_user)
        sign_in(user)
        post :create, page: attributes_for(:page, title: "Foo")
        Page.last.user.should == user
      end

      it "sets a flash notice" do
        post :create, page: attributes_for(:page)
        flash[:notice].should_not be_empty
      end

      it "redirects to the 'show' action for the created page" do
        post :create, page: attributes_for(:page)
        response.should redirect_to page_path(Page.last)
      end
    end

    context "when creation is unsuccesssful" do
      it "renders the new page" do
        post :create, page: attributes_for(:page, title: nil)
        response.should render_template :new
      end

      it "assigns the page" do
        post :create, page: attributes_for(:page, title: nil)
        assigns(:page).should be_a Page
      end

      it "sets a flash error" do
        post :create, page: attributes_for(:page, title: nil)
        flash[:error].should_not be_empty
      end
    end
  end

  context "PUT 'update'" do
    let!(:wiki) { create(:wiki, subdomain: "foo") }
    let!(:user) { create(:active_user, wiki: wiki) }
    before(:each) do
      @request.host = "foo.example.com"
      sign_in(user)
    end

    context "when the updation is successful" do
      it "updates the page's title" do
        page = create(:page, wiki: wiki, user: user)
        put :update, id: page.id, page: {title: "Foo"}
        page.reload.title.should == "Foo"
      end

      it "updates the page's text" do
        page = create(:page, wiki: wiki, user: user)
        put :update, id: page.id, page: {title: "Bar"}
        page.reload.title.should == "Bar"
      end

      it "redirects to the 'show' action for that page" do
        page = create(:page, wiki: wiki, user: user)
        put :update, id: page.id, page: {title: "Bar"}
        response.should redirect_to page_path(page)
      end

      it "sets a flash notice" do
        page = create(:page, wiki: wiki, user: user)
        put :update, id: page.id, page: {title: "Bar"}
        flash[:notice].should_not be_empty
      end

      it "destroys the draft page" do
        page = create(:page, wiki: wiki, user: user)
        draft_page = DraftPage.create(user_id: user.id, wiki_id: wiki.id, page: page)
        put :update, id: page.id, page: {title: "Bar"}
        expect { draft_page.reload }.to raise_error { ActiveRecord::RecordNotFound }
      end
    end

    context "when the updation is unsuccessful" do
      it "assigns the draft page" do
        page = create(:page, wiki: wiki, user: user)
        put :update, id: page.id, page: {title: nil}
        assigns(:draft_page).should be_a DraftPage
      end

      it "assigns the page" do
        page = create(:page, wiki: wiki, user: user)
        put :update, id: page.id, page: {title: nil}
        assigns(:page).should == page
      end

      it "renders the edit page" do
        page = create(:page, wiki: wiki, user: user)
        put :update, id: page.id, page: { title: nil }
        response.should render_template :edit
      end

      it "sets a flash error" do
        page = create(:page, wiki: wiki, user: user)
        put :update, id: page.id, page: { title: nil }
        flash[:error].should_not be_empty
      end

      it "doesn't destroy the draft page" do
        page = create(:page, wiki: wiki, user: user)
        draft_page = DraftPage.create(user_id: user.id, wiki_id: wiki.id, page: page)
        put :update, id: page.id, page: {title: nil}
        expect { draft_page.reload }.not_to raise_error { ActiveRecord::RecordNotFound }
      end
    end
  end
end
