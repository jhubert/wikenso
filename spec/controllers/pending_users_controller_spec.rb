require 'spec_helper'

describe PendingUsersController do
  let!(:wiki) { create(:wiki, subdomain: "foo") }
  before(:each) { @request.host = "foo.example.com" }
  after(:each) { sign_out }

  context "POST 'create'" do
    let(:wiki) { create(:wiki, subdomain: "foo") }
    before(:each) do
      @request.host = "foo.example.com"
      sign_in(create(:active_user, wiki: wiki))
    end

    context "when the creation succeeds" do
      it "creates a pending user" do
        expect { post :create, user: attributes_for(:active_user, wiki: wiki) }.to change { PendingUser.count }.by(1)
      end

      it "doesn't create an active user" do
        expect { post :create, user: attributes_for(:active_user, wiki: wiki) }.not_to change { ActiveUser.count }
      end

      it "redirects to the users index page" do
        post :create, user: attributes_for(:active_user, wiki: wiki)
        response.should redirect_to users_path
      end

      it "creates a user belonging to the current wiki" do
        post :create, user: attributes_for(:active_user, wiki: wiki)
        User.last.wiki.should == wiki
      end

      it "creates an invitation for the user" do
        post :create, user: attributes_for(:active_user, wiki: wiki)
        User.last.invitations.should_not be_empty
      end
    end

    context "when the creation fails" do
      it "doesn't create a user" do
        user_attributes = attributes_for(:active_user, wiki: wiki, email: "thisisnotanemail")
        expect { post :create, user: user_attributes }.not_to change { User.count }
      end

      it "returns a 400" do
        user_attributes = attributes_for(:active_user, wiki: wiki, email: "thisisnotanemail")
        post :create, user: user_attributes
        response.status.should == 400
      end

      it "renders the 'index' template" do
        user_attributes = attributes_for(:active_user, wiki: wiki, email: "thisisnotanemail")
        post :create, user: user_attributes
        response.should render_template :index
      end

      it "assigns the wiki" do
        user_attributes = attributes_for(:active_user, wiki: wiki, email: "thisisnotanemail")
        post :create, user: user_attributes
        assigns(:wiki).should == wiki
      end

      it "sets the flash error" do
        user_attributes = attributes_for(:active_user, wiki: wiki, email: "thisisnotanemail")
        post :create, user: user_attributes
        flash[:error].should include "Email is invalid"
      end
    end

    it "doesn't allow access if the user is not logged in" do
      sign_out
      post :create, user: attributes_for(:active_user, wiki: wiki)
      response.should redirect_to new_session_path
    end
  end

  context "GET 'edit'" do
    context "for a valid invitation code" do
      it "assigns the pending user who owns the passed invitation code" do
        user = create(:pending_user, wiki: wiki)
        invitation = create(:user_invitation, code: "abcd", user: user)
        get 'edit', invitation_code: "abcd"
        assigns(:user).should == user
      end

      it "assigns the invitation code" do
        user = create(:pending_user, wiki: wiki)
        invitation = create(:user_invitation, code: "abcd", user: user)
        get 'edit', invitation_code: "abcd"
        assigns(:invitation_code).should == "abcd"
      end

      it "returns a 400 if the user's wiki and the subdomain don't match" do
        user = create(:pending_user, wiki: wiki)
        create(:wiki, subdomain: "abcd")
        @request.host = "abcd.example.com"
        get 'edit', invitation_code: create(:user_invitation, user: user).code
        response.status.should == 400
      end

      it "returns http success" do
        user = create(:pending_user, wiki: wiki)
        get 'edit', invitation_code: create(:user_invitation, user: user).code
        response.should be_success
      end
    end

    context "for an invalid invitation code" do
      it "returns a 400" do
        get 'edit', invitation_code: "FOO"
        response.status.should == 400
      end
    end
  end

  context "PUT 'update'" do
    context "when the save is successful" do
      it "updates the user with the given name" do
        user = create(:pending_user, :invitation, wiki: wiki, name: "Foo Bar")
        put :update, invitation_code: user.invitations.first.code, user: {name: "Bar Foo", password: "foo", password_confirmation: "foo"}
        User.find(user.id).name.should == "Bar Foo"
      end

      it "updates the user's password" do
        user = create(:pending_user, :invitation, wiki: wiki)
        put :update, invitation_code: user.invitations.first.code, user: {password: "foo", password_confirmation: "foo"}
        User.find(user.id).reload.password_digest.should_not be_empty
      end

      it "makes the user active" do
        user = create(:pending_user, :invitation, wiki: wiki)
        put :update, invitation_code: user.invitations.first.code, user: {password: "foo", password_confirmation: "foo"}
        User.find(user.id).should be_a ActiveUser
      end

      it "removes all invitations belonging to the user" do
        user = create(:pending_user, wiki: wiki)
        invitations = create_list(:user_invitation, 5, user: user)
        expect {
          put :update, invitation_code: user.invitations.first.code, user: {password: "foo", password_confirmation: "foo"}
        }.to change { user.invitations.count }.from(5).to(0)
      end

      it "logs the user in" do
        user = create(:pending_user, :invitation, wiki: wiki)
        put :update, invitation_code: user.invitations.first.code, user: { password: "foo", password_confirmation: "foo" }
        user_signed_in?.should be_true
      end

      it "redirects to the wiki home page" do
        user = create(:pending_user, :invitation, wiki: wiki)
        put :update, invitation_code: user.invitations.first.code, user: { password: "foo", password_confirmation: "foo" }
        response.should redirect_to root_path(subdomain: "foo")
      end

      it "sets a flash notice" do
        user = create(:pending_user, :invitation, wiki: wiki)
        put :update, invitation_code: user.invitations.first.code, user: { password: "foo", password_confirmation: "foo" }

      end
    end

    context "when the save is unsuccessful" do
      it "doesn't log the user in" do
        user = create(:pending_user, :invitation, wiki: wiki)
        put :update, invitation_code: user.invitations.first.code, user: { name: nil }
        user_signed_in?.should be_false
      end

      it "renders the :edit template" do
        user = create(:pending_user, :invitation, wiki: wiki)
        put :update, invitation_code: user.invitations.first.code, user: { name: nil }
        response.should render_template :edit
      end

      it "assigns the user" do
        user = create(:pending_user, :invitation, wiki: wiki)
        put :update, invitation_code: user.invitations.first.code, user: { name: nil }
        assigns(:user).should == user
      end

      it "assigns the invitation code" do
        user = create(:pending_user, :invitation, wiki: wiki)
        put :update, invitation_code: user.invitations.first.code, user: { name: nil }
        assigns(:invitation_code).should == user.invitations.first.code
      end
    end

    context "authorization" do
      it "doesn't allow updating of a user from another wiki" do
        user = create(:pending_user, :invitation, wiki: create(:wiki))
        put :update, invitation_code: user.invitations.first.code, user: { password: "foo", password_confirmation: "foo", name: "foo" }
        User.find(user.id).reload.name.should_not == "foo"
      end

      it "doesn't allow an invalid invitation code" do
        user = create(:pending_user, :invitation, wiki: wiki)
        put :update, invitation_code: "notacode", user: { password: "foo", password_confirmation: "foo", name: "foo" }
        User.find(user.id).reload.name.should_not == "foo"
      end
    end
  end
end
