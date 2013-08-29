require 'spec_helper'

describe PageVersionsController do
  describe "GET 'index'" do
    let!(:wiki) { create(:wiki, subdomain: "foo") }
    before(:each) do
      @request.host = "foo.example.com"
      sign_in(create(:active_user))
    end

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
        session[:user_id] = nil
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
end
