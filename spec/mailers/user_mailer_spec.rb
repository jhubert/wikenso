require "spec_helper"

describe UserMailer do
  context "when inviting a pending user to join the wiki" do
    let(:wiki) { create(:wiki)}
    let(:user) { create(:pending_user, wiki: wiki) }

    it "contains the invitation link" do
      invitation = create(:user_invitation, user: user)
      mail = UserMailer.invitation_mail(user, wiki)
      mail.body.should include user.decorate.invitation_link
    end
  end
end
