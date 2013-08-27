require 'spec_helper'

describe UserInvitation do
  context "#create_with_random_code" do
    it "creates an invitation with a randomly generated invitation code" do
      invitation = UserInvitation.create_with_random_code
      invitation.code.should_not be_nil
    end

    it "generates a different code for each invitation" do
      first_invitation = UserInvitation.create_with_random_code
      second_invitation = UserInvitation.create_with_random_code
      first_invitation.code.should_not == second_invitation.code
    end

    it "persists the created invitation" do
      expect { UserInvitation.create_with_random_code }.to change { UserInvitation.count }.by(1)
    end
  end
end
