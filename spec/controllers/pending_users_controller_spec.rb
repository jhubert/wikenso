require 'spec_helper'

describe PendingUsersController do
  let!(:wiki) { create(:wiki, subdomain: "foo") }
  before(:each) { @request.host = "foo.example.com" }

  describe "GET 'edit'" do
    context "for a valid invitation code" do
      it "assigns the pending user who owns the passed invitation code" do
        user = create(:pending_user, wiki: wiki)
        invitation = create(:user_invitation, code: "abcd", user: user)
        get 'edit', invitation_code: "abcd"
        assigns(:user).should == user
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
end
