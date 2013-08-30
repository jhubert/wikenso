require 'spec_helper'

describe UserInvitationEmailsController do
  let!(:wiki) { create(:wiki, subdomain: "foo", name: "foo") }
  before(:each) do
    @request.host = "foo.example.com"
    sign_in(create(:active_user))
  end

  describe "GET 'create'" do
    context "if the user ID is valid" do
      it "sends out an email" do
        user = create(:pending_user, :invitation, wiki: wiki)
        expect { get 'create', user_id: user.id }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "addresses the email to the given user" do
        user = create(:pending_user, :invitation, wiki: wiki)
        get 'create', user_id: user.id
        ActionMailer::Base.deliveries.last.to.should == [user.email]
      end

      it "contains the wiki name in the subject" do
        user = create(:pending_user, :invitation, wiki: wiki)
        get 'create', user_id: user.id
        ActionMailer::Base.deliveries.last.subject.should include "foo"
      end

      it "redirects to the users index page" do
        user = create(:pending_user, :invitation, wiki: wiki)
        get 'create', user_id: user.id
        response.should redirect_to users_path(subdomain: "foo")
      end

      it "sets a flash notice" do
        user = create(:pending_user, :invitation, wiki: wiki)
        get 'create', user_id: user.id
        flash[:notice].should_not be_empty
      end
    end

    context "if the user ID is invalid" do
      it "redirects to the users index page" do
        get 'create', user_id: 500
        response.should redirect_to users_path(subdomain: "foo")
      end

      it "sets a flash error" do
        get 'create', user_id: 500
        flash[:error].should_not be_empty
      end
    end

    context "authorization" do
      it "doesn't allow access if a user isn't logged in" do
        session[:user_id] = nil
        user = create(:pending_user, :invitation, wiki: wiki)
        get 'create', user_id: user.id
        response.should redirect_to new_session_path
      end

      it "doesn't send an email for a user belonging to another wiki" do
        user = create(:pending_user, :invitation, wiki: create(:wiki))
        expect { get 'create', user_id: user.id }.not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end
end
