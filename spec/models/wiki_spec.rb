require 'spec_helper'

describe Wiki do
  context "scopes" do
    context "when finding by name in a case insensitive way" do
      it "finds by name" do
        wiki = FactoryGirl.create(:wiki, name: "Foo")
        Wiki.case_insensitive_find_by_name("Foo").should == [wiki]
      end

      it "disregards case" do
        wiki = FactoryGirl.create(:wiki, name: "UpperCase")
        Wiki.case_insensitive_find_by_name("uPPeRcAsE").should == [wiki]
      end
    end
  end
end
