require 'spec_helper'

describe PendingUser do
  context ".create_with_invitation" do
    context "when creation is successful" do
      it "creates a pending user" do
        expect {
          PendingUser.create_with_invitation(email: "foo@foo.com")
        }.to change { PendingUser.count }.by(1)
      end

      it "creates a user with the given email address" do
        user = PendingUser.create_with_invitation(email: "foo@foo.com")
        user.reload.email.should == "foo@foo.com"
      end

      it "creates a user belonging to the given wiki" do
        wiki = create(:wiki)
        user = PendingUser.create_with_invitation(email: "foo@foo.com", wiki_id: wiki.id)
        user.reload.email.should == "foo@foo.com"
      end

      it "creates an invitation for the user" do
        user = PendingUser.create_with_invitation(email: "foo@foo.com")
        user.invitations.should_not be_empty
      end

      it "returns the created user" do
        PendingUser.create_with_invitation(email: "foo@foo.com").should be_a PendingUser
      end
    end

    context "when creation is unsuccessful" do
      it "doesn't create a pending user" do
        expect {
          PendingUser.create_with_invitation(email: "notanemail")
        }.not_to change { PendingUser.count }
      end

      it "doesn't create an invitation for the user" do
        expect {
          PendingUser.create_with_invitation(email: "notanemail")
        }.not_to change { UserInvitation.count }
      end

      it "returns the pending user with errors" do
        user = PendingUser.create_with_invitation(email: "notanemail")
        user.errors.should_not be_empty
      end
    end
  end

  context ".find_by_invitation_code_and_wiki_id" do
    let(:wiki) { create(:wiki) }

    it "returns the user who owns the given invitation code" do
      user = create(:pending_user, wiki: wiki)
      invitation = create(:user_invitation, code: "foo", user: user)
      PendingUser.find_by_invitation_code_and_wiki_id("foo", wiki.id).should == user
    end

    it "returns nil if the user belongs to a different wiki" do
      user = create(:pending_user, wiki: create(:wiki))
      invitation = create(:user_invitation, code: "foo", user: user)
      PendingUser.find_by_invitation_code_and_wiki_id("foo", wiki.id).should be_nil
    end

    it "returns nil if no user owns the given invitation code" do
      PendingUser.find_by_invitation_code_and_wiki_id("bar", wiki.id).should be_nil
    end
  end

  context "#invitation_code" do
    it "returns the invitation code for the user" do
      user = create(:pending_user)
      invitation = create(:user_invitation, user: user)
      user.invitation_code.should == invitation.code
    end

    it "returns the latest code if there are multiple" do
      user = create(:pending_user)
      first_invitation = create(:user_invitation, user: user)
      second_invitation = create(:user_invitation, user: user)
      user.invitation_code.should == second_invitation.code
    end
  end

  context "#activate_with_params" do
    context "when the activation succeeds" do
      it "updates the user with the given name" do
        user = create(:pending_user, name: "Foo Bar")
        user.activate_with_params(name: "Bar Foo", password: "foo", password_confirmation: "foo")
        User.find(user.id).reload.name.should == "Bar Foo"
      end

      it "updates the user's password and password confirmation" do
        user = create(:pending_user, password: nil, password_confirmation: nil)
        active_user = user.activate_with_params(password: "foo", password_confirmation: "foo")
        active_user.authenticate("foo").should be_true
      end

      it "makes the user active" do
        user = create(:pending_user)
        user.activate_with_params(password: "foo", password_confirmation: "foo")
        User.find(user.id).should be_a ActiveUser
      end

      it "returns the active user" do
        user = create(:pending_user)
        user.activate_with_params(name: "Bar Foo", password: "foo", password_confirmation: "foo").should be_a ActiveUser
      end
    end

    context "when the activation fails" do
      it "doesn't update the user" do
        user = create(:pending_user, name: "Foobar")
        user.activate_with_params(email: "notanemail", name: "Hello!")
        user.reload.name.should == "Foobar"
      end

      it "doesn't change the type of the user" do
        user = create(:pending_user)
        user.activate_with_params(email: "notanemail")
        User.find(user.id).should be_a PendingUser
      end

      it "returns false" do
        user = create(:pending_user)
        user.activate_with_params(email: "notanemail").should be_false
      end
    end
  end
end