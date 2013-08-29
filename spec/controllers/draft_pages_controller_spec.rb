require 'spec_helper'

describe DraftPagesController do
  let!(:wiki) { create(:wiki, subdomain: "foo") }
  let!(:user) { create(:active_user, wiki: wiki) }
  before(:each) do
    @request.host = "foo.example.com"
    sign_in(user)
  end

  context "DELETE 'destroy'" do
    it "destroys the draft corresponding to the passed ID" do
      draft_page = create(:draft_page, wiki: wiki, user: user)
      delete :destroy, id: draft_page.id
      expect { draft_page.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "doesn't delete any other draft pages" do
      draft_page = create(:draft_page, :page, wiki: wiki, user: user)
      other_draft_page = create(:draft_page, :page)
      delete :destroy, id: draft_page.id
      expect { other_draft_page.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
    end

    it "doesn't delete a draft page belonging to another wiki" do
      other_wiki = create(:wiki, subdomain: "bar")
      draft_page = create(:draft_page, wiki: other_wiki, user: user)
      delete :destroy, id: draft_page.id
      expect { draft_page.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
    end

    it "doesn't delete a draft page belonging to another user" do
      current_user = create(:active_user, wiki: wiki)
      other_user = create(:active_user, wiki: wiki)
      sign_in(current_user)

      draft_page = create(:draft_page, user: other_user, wiki: wiki)
      delete :destroy, id: draft_page.id
      expect { draft_page.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
    end

    it "denies access if a user isn't logged in" do
      draft_page = create(:draft_page, wiki: wiki, user: user)
      session[:user_id] = nil
      delete :destroy, id: draft_page.id
      response.should redirect_to new_session_path
    end

    context "when the passed ID is valid" do
      it "redirects to the root page of the wiki" do
        draft_page = create(:draft_page, wiki: wiki, user: user)
        delete :destroy, id: draft_page.id
        response.should redirect_to root_path
      end

      it "sets a flash notice" do
        draft_page = create(:draft_page, wiki: wiki, user: user)
        delete :destroy, id: draft_page.id
        flash[:notice].should_not be_empty
      end
    end

    context "when the passed ID is invalid" do
      it "returns a 400" do
        delete :destroy, id: 12345
        response.status.should == 400
      end

      it "sets a flash error" do
        delete :destroy, id: 12345
        response.status.should == 400
        flash[:error].should_not be_empty
      end
    end
  end
end
