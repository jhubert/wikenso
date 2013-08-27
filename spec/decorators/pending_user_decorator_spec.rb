require 'spec_helper'

describe PendingUserDecorator do
  context "#invitation_link" do
    it "returns a link containing the subdomain of the user's wiki" do
      wiki = create(:wiki, subdomain: "foo")
      user = create(:pending_user, :invitation, wiki: wiki).decorate
      user.invitation_link.should include "http://foo"
    end

    it "returns a link containing the invitation code of the user's wiki" do
      wiki = create(:wiki, subdomain: "foo")
      user = create(:pending_user, wiki: wiki).decorate
      invitation = create(:user_invitation, user: user, code: "foo123")
      user.invitation_link.should include "foo123"
    end
  end
end
