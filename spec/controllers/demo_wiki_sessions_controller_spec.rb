require 'spec_helper'

describe DemoWikiSessionsController do
  describe "GET 'create'" do
    let(:demo_wiki) { create(:wiki) }
    before(:each) do
      Wiki.stub(:demo_wiki).and_return(demo_wiki.reload)
    end

    it "signs in the first user of the demo wiki" do
      user = create(:active_user, wiki: demo_wiki)
      post :create
      controller.current_user.should == user
    end

    it "redirects to the home page of the demo wiki" do
      user = create(:active_user, wiki: demo_wiki)
      post :create
      response.should redirect_to root_url(subdomain: demo_wiki.subdomain)
    end
  end
end
