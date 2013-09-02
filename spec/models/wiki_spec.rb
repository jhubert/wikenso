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

  context ".build_with_active_user" do
    it "builds an active user if a single user is passed" do
      wiki_params = attributes_for(:wiki)
      user_params = attributes_for(:active_user, type: nil)
      wiki = Wiki.build_with_active_user(wiki_params.merge(users_attributes: {"0" => user_params}))
      wiki.users.first.should be_a ActiveUser
    end

    it "doesn't build a user if none are passed" do
      wiki_params = attributes_for(:wiki)
      wiki = Wiki.build_with_active_user(wiki_params)
      wiki.users.should be_empty
    end

    it "builds multiple active users if more than one are passed" do
      wiki_params = attributes_for(:wiki)
      users_attributes = 5.times.inject({}) do |hash, index|
        hash[index.to_s] = attributes_for(:active_user, type: nil)
        hash
      end
      wiki = Wiki.build_with_active_user(wiki_params.merge(users_attributes: users_attributes))
      wiki.users.map(&:type).uniq.should == ["ActiveUser"]
    end
  end

  context "#name" do
    it "returns the name if it exists" do
      wiki = create(:wiki, name: "This is a name")
      wiki.name.should == "This is a name"
    end

    it "returns the subdomain if a name doesn't exist" do
      wiki = create(:wiki, name: nil, subdomain: "foo")
      wiki.name.should == "foo"
    end

    it "returns the subdomain if the name is an empty string" do
      wiki = create(:wiki, name: "", subdomain: "foo")
      wiki.name.should == "foo"
    end
  end

  context "#save_with_seed_page" do
    before(:each) { create(:welcome_page) }

    it "saves the wiki" do
      wiki = build(:wiki)
      expect { wiki.save_with_seed_page }.to change { Wiki.count }.by(1)
    end

    it "saves the wiki's name" do
      wiki = build(:wiki, name: "Foo")
      wiki.save_with_seed_page
      wiki.reload.name.should == "Foo"
    end

    context "when creating the seed page" do
      it "creates a page belonging to the wiki" do
        wiki = build(:wiki)
        wiki.save_with_seed_page
        wiki.reload.pages.should_not be_empty
      end

      it "creates a page with the same title as the last welcome page" do
        create(:welcome_page, title: "Foo!")
        wiki = build(:wiki)
        wiki.save_with_seed_page
        wiki.reload.pages.first.title.should == "Foo!"
      end

      it "creates a page with the same text as the last welcome page" do
        create(:welcome_page, text: "Foo!")
        wiki = build(:wiki)
        wiki.save_with_seed_page
        wiki.reload.pages.first.text.should == "Foo!"
      end
    end

    it "returns true when the save succeeds" do
      wiki = build(:wiki)
      wiki.save_with_seed_page.should be_true
    end

    context "for an unsuccessful save" do
      context "if the wiki save fails" do
        it "doesn't create a page" do
          wiki = build(:wiki)
          Wiki.any_instance.stub(:save!).and_raise(ActiveRecord::RecordInvalid.new(wiki))
          expect { wiki.save_with_seed_page }.not_to change { Page.count }
        end

        it "returns false" do
          wiki = build(:wiki)
          Wiki.any_instance.stub(:save!).and_raise(ActiveRecord::RecordInvalid.new(wiki))
          wiki.save_with_seed_page.should be_false
        end
      end

      context "if the page save fails" do
        before(:each) do
          ActiveRecord::Associations::CollectionProxy.any_instance.stub(:create!).
              and_raise(ActiveRecord::RecordInvalid.new(build(:page)))
        end

        it "doesn't create a wiki" do
          wiki = build(:wiki)
          expect { wiki.save_with_seed_page }.not_to change { Wiki.count }
        end

        it "returns false" do
          wiki = build(:wiki)
          wiki.save_with_seed_page.should be_false
        end
      end
    end
  end
end
