require 'spec_helper'

describe UserInvitationEmailsController do
  describe "GET 'create'" do
    context "if the user ID is valid" do
      it "sends out an email" do
        user = create(:pending_user, :wiki, :invitation)
        expect { get 'create', user_id: user.id }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "addresses the email to the given user" do
        user = create(:pending_user, :wiki, :invitation)
        get 'create', user_id: user.id
        ActionMailer::Base.deliveries.last.to.should == [user.email]
      end

      it "contains the wiki name in the subject" do
        wiki = create(:wiki, subdomain: "foo")
        user = create(:pending_user, :invitation, wiki: wiki)
        get 'create', user_id: user.id
        ActionMailer::Base.deliveries.last.subject.should include "foo"
      end

      it "redirects to the users index page" do
        wiki = create(:wiki, subdomain: "foo")
        user = create(:pending_user, :wiki, :invitation)
        get 'create', user_id: user.id
        response.should redirect_to users_path(subdomain: "foo")
      end

      it "sets a flash notice" do
        wiki = create(:wiki, subdomain: "foo")
        user = create(:pending_user, :wiki, :invitation)
        get 'create', user_id: user.id
        flash[:notice].should_not be_empty
      end
    end

    context "if the user ID is invalid" do
      it "redirects to the users index page" do
        wiki = create(:wiki, subdomain: "foo")
        get 'create', user_id: 500
        response.should redirect_to users_path(subdomain: "foo")
      end

      it "sets a flash error" do
        wiki = create(:wiki, subdomain: "foo")
        get 'create', user_id: 500
        flash[:error].should_not be_empty
      end
    end
  end
end
