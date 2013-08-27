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

  context "#create_pending_user" do
    let(:wiki) { create(:wiki) }

    context "when the creation is successful" do
      it "creates a pending user" do
        expect { wiki.create_pending_user("foo@example.com") }.to change { PendingUser.count }.by(1)
      end

      it "returns the created user" do
        wiki.create_pending_user("foo@example.com").should be_a PendingUser
      end

      it "creates a user with the passed email" do
        user = wiki.create_pending_user("foo@example.com")
        User.last.email.should == "foo@example.com"
      end

      it "creates a user belonging to the current wiki" do
        user = wiki.create_pending_user("foo@example.com")
        User.last.wiki.should == wiki
      end

      it "creates an invitation for the user" do
        user = wiki.create_pending_user("foo@example.com")
        user.invitations.should_not be_empty
      end

      context "when sending an invitation email" do
        it "sends an email" do
          expect {
            wiki.create_pending_user("foo@example.com")
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it "addresses the email to the created user" do
          wiki.create_pending_user("foo@example.com")
          ActionMailer::Base.deliveries.last.to.should == ["foo@example.com"]
        end
      end
    end

    context "when the creation is unsuccessful" do
      it "returns the user with errors" do
        wiki.create_pending_user("thisisnotanemail").errors.should be_present
      end

      it "doesn't create a user" do
        expect { wiki.create_pending_user("thisisnotanemail") }.not_to change { User.count }
      end
    end
  end
end
