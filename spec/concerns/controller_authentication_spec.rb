require 'spec_helper'

describe ControllerAuthentication, type: :controller do
  controller { include ControllerAuthentication }

  it "signs a user in by saving the ID in the session" do
    user = FactoryGirl.create(:user)
    @controller.sign_in(user)
    session[:user_id].should == user.id
  end

  context "when finding the current user" do
    it "returns the user if there is one logged in" do
      user = FactoryGirl.create(:user)
      @controller.sign_in(user)
      @controller.current_user.should == user
    end

    it "returns nil if no user is logged in" do
      user = FactoryGirl.create(:user)
      @controller.current_user.should be_nil
    end
  end

  context "when checking if a user is logged in" do
    it "returns true if a user is logged in" do
      @controller.sign_in(FactoryGirl.create(:user))
      @controller.user_signed_in?.should be_true
    end

    it "returns false if a user is logged in" do
      @controller.user_signed_in?.should be_false
    end
  end
end