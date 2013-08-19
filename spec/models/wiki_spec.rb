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

  context "validations" do
    context "when validating the subdomain" do
      it "allows a subdomain with only alphanumeric characters" do
        wiki = build(:wiki, subdomain: "Alphanumer1c")
        wiki.should be_valid
      end

      it "doesn't allow a subdomain with special characters" do
        wiki = build(:wiki, subdomain: "Spec!@l")
        wiki.should_not be_valid
      end

      it "doesn't allow a subdomain with spaces" do
        wiki = build(:wiki, subdomain: "Wiki with Spaces")
        wiki.should_not be_valid
      end
    end
  end
end
