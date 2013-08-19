require 'spec_helper'

describe Wiki do
  context "scopes" do
    context "when finding by name in a case insensitive way" do
      it "finds by subdomain" do
        wiki = create(:wiki, subdomain: "Foo")
        Wiki.case_insensitive_find_by_subdomain("Foo").should == [wiki]
      end

      it "disregards case" do
        wiki = create(:wiki, subdomain: "UpperCase")
        Wiki.case_insensitive_find_by_subdomain("uPPeRcAsE").should == [wiki]
      end
    end
  end
end
