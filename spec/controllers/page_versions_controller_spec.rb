require 'spec_helper'

describe PageVersionsController do
  let!(:wiki) { create(:wiki, subdomain: "foo") }
  before(:each) do
    @request.host = "foo.example.com"
    sign_in(create(:active_user))
  end

  describe "GET 'index'" do
    it "assigns the versions of the page corresponding to the passed ID" do
      page = create(:page, wiki: wiki)
      get 'index', page_id: page.id
      assigns(:page_versions).should == page.versions
    end

    it "assigns the page" do
      page = create(:page, wiki: wiki)
      get 'index', page_id: page.id
      assigns(:page).should == page
    end

    it "raises an error if the page ID is invalid" do
      expect { get 'index', page_id: 1234 }.to raise_error
    end

    context "authorization" do
      it "denies access to non-logged-in users" do
        sign_out
        page = create(:page, wiki: wiki)
        get 'index', page_id: page.id
        response.should redirect_to new_session_path
      end

      it "raises an error if the page belongs to another wiki" do
        page = create(:page, wiki: create(:wiki))
        expect { get 'index', page_id: page.id }.to raise_error
      end
    end
  end

  describe "GET 'show'" do
    it "assigns the version specified by the given ID" do
      page = create(:page, wiki: wiki)
      page_version = create(:page_version, item: page)
      get :show, id: page_version.id, page_id: page.friendly_id
      assigns(:page_version).should == page_version
    end

    it "assigns the page specified by the given friendly page ID" do
      page = create(:page, wiki: wiki)
      page_version = create(:page_version, item: page)
      get :show, id: page_version.id, page_id: page.friendly_id
      assigns(:page).should == page
    end

    it "returns a 404 if the ID points to a version belonging to another page" do
      page = create(:page, wiki: wiki)
      page_version = create(:page_version, item: create(:page))
      expect { get :show, id: page_version.id, page_id: page.friendly_id }.to raise_error
    end

    it "returns a 404 if the page ID is invalid" do
      page = create(:page, wiki: wiki)
      page_version = create(:page_version, item: page)
      expect { get :show, id: page_version.id, page_id: 1234 }.to raise_error(ActionController::RoutingError)
    end

    it "returns a 404 if the ID is invalid" do
      page = create(:page, wiki: wiki)
      page_version = create(:page_version, item: page)
      expect { get :show, id: 1234, page_id: page.friendly_id }.to raise_error(ActionController::RoutingError)
    end

    it "returns a 404 if the page belongs to a different wiki" do
      page = create(:page, wiki: create(:wiki, subdomain: "bar"))
      page_version = create(:page_version, item: page)
      expect { get :show, id: page_version.id, page_id: page.friendly_id }.to raise_error(ActionController::RoutingError)
    end
  end
end
