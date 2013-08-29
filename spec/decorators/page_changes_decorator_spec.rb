require 'spec_helper'

describe PageChangesDecorator do
  context "#update_time_string" do
    it "returns an absolute time if the `created_at` is older than 7 days" do
      Timecop.travel("August 10th 2013 14:00")
      version = Timecop.freeze(8.days.ago) { create(:page_version) }
      PageChangesDecorator.new(version).update_time_string.should == "Aug 2nd 2013"
    end

    it "returns a relative time if the `created_at` is newer than 7 days" do
      Timecop.travel("August 10th 2013 14:00")
      version = Timecop.freeze(4.days.ago) { create(:page_version) }
      PageChangesDecorator.new(version).update_time_string.should == "4 days ago"
    end
  end
end
