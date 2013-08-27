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
end