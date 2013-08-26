require 'spec_helper'

describe User do
  context 'scopes' do
    it "returns all active users" do
      active_user = create(:active_user)
      pending_user = create(:pending_user)
      User.active.should == [active_user]
    end

    it "returns all pending users" do
      active_user = create(:active_user)
      pending_user = create(:pending_user)
      User.pending.should == [pending_user]
    end
  end
end
