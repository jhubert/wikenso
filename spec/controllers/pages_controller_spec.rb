require 'spec_helper'

describe PagesController do

  context "GET 'edit'" do
    before(:each) { sign_in(create(:user)) }

    let(:wiki) { create(:wiki, subdomain: "foo") }
    before(:each) { @request.host = "foo.example.com" }

    it "assigns the page corresponding to the passed friendly ID" do
      page = create(:page, wiki: wiki, title: "foo")
      get :edit, id: "foo"
      assigns(:page).should == page
    end

    it "raises an error if the ID is invalid" do
      expect { get :edit, id: 1234 }.to raise_error
    end

    it "raises an error if the ID points to a page belonging to another wiki" do
      page = create(:page, wiki: create(:wiki))
      expect { get :edit, id: page.id }.to raise_error
    end
  end

  context "GET 'show'" do
    before(:each) { sign_in(create(:user)) }

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

end
