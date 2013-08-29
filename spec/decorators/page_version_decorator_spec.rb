require 'spec_helper'

describe PageVersionDecorator do
  context "#update_time_string" do
    it "returns an absolute time if the `created_at` is older than 7 days" do
      Timecop.travel("August 10th 2013 14:00")
      version = Timecop.freeze(8.days.ago) { create(:page_version) }
      PageVersionDecorator.new(version).created_at_time_string.should == "Aug 2nd 2013"
    end

    it "returns a relative time if the `created_at` is newer than 7 days" do
      Timecop.travel("August 10th 2013 14:00")
      version = Timecop.freeze(4.days.ago) { create(:page_version) }
      PageVersionDecorator.new(version).created_at_time_string.should == "4 days ago"
    end
  end

  context "#reify" do
    it "`reify`s the subsequent version if there is one", versioning: true do
      page = create(:page, title: "foo")
      page.update(title: "bar")
      decorator = PageVersionDecorator.decorate(page.versions.first)
      decorator.reify.title.should == "foo"
    end

    it "returns the current model if there is no subsequent version", versioning: true do
      page = create(:page, title: "foo")
      page.update(title: "bar")
      decorator = PageVersionDecorator.decorate(page.versions.last)
      decorator.reify.title.should == "bar"
    end
  end
end
