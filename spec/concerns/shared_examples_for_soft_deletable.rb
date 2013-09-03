require 'spec_helper'

shared_examples "soft deletable" do
  it "contains a `deleted_at` column" do
    described_class.new.should respond_to :deleted_at
  end

  context "when soft deleting" do
    it "sets the deleted_at column to the time of soft delete" do
      time = Time.now
      record = FactoryGirl.create(described_class)
      Timecop.freeze(time) { record.soft_delete }
      record.reload.deleted_at.to_i.should == time.to_i
    end

    it "doesn't appear in scoped queries anymore" do
      record = FactoryGirl.create(described_class)
      record.soft_delete
      described_class.all.should_not include record
    end

    it "appears in unscoped queries" do
      record = FactoryGirl.create(described_class)
      record.soft_delete
      described_class.unscoped.to_a.should include record
    end
  end
end