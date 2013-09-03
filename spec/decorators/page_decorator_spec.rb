require 'spec_helper'

describe PageDecorator do
  context "#show_history?" do
    it "returns true if the page contains a versions with a user" do
      user = create(:active_user)
      page = create(:page)
      create(:page_version, item: page, whodunnit: user.id)
      page.decorate.show_history?.should be_true
    end

    it "returns false if all the page's versions don't have a user set" do
      page = create(:page)
      create_list(:page_version, 5, item: page, whodunnit: nil)
      page.decorate.show_history?.should be_false
    end

    it "returns true if some of the page's versions don't have a user set" do
      user = create(:active_user)
      page = create(:page)
      create_list(:page_version, 5, item: page, whodunnit: user.id)
      create_list(:page_version, 5, item: page, whodunnit: nil)
      page.decorate.show_history?.should be_true
    end
  end
end
