require 'spec_helper'

describe WelcomePage do
  context "#latest" do
    it "fetches the newest welcome page" do
      first_page = Timecop.freeze("2013/5/05") { create(:welcome_page) }
      second_page = Timecop.freeze("2013/6/06") { create(:welcome_page) }
      WelcomePage.latest.should == second_page
    end

    it "returns `nil` if no welcome pages exist" do
      WelcomePage.latest.should be_nil
    end
  end
end
