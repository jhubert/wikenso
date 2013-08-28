require 'spec_helper'

describe Page do
  context "#find_or_create_draft_page_for_user" do
    let(:user) { create(:active_user) }
    let(:wiki) { create(:wiki) }

    it "creates a draft page" do
      page = create(:page, wiki: wiki)
      expect { page.find_or_create_draft_page_for_user(user) }.to change { DraftPage.count }.by(1)
    end

    it "creates a draft page belonging to the current page" do
      page = create(:page, wiki: wiki)
      draft_page = page.find_or_create_draft_page_for_user(user)
      draft_page.page.should == page
    end

    it "creates a draft page belonging to the given user" do
      page = create(:page, wiki: wiki)
      draft_page = page.find_or_create_draft_page_for_user(user)
      draft_page.user.should == user
    end

    it "creates a draft page belonging to the current wiki" do
      page = create(:page, wiki: wiki)
      draft_page = page.find_or_create_draft_page_for_user(user)
      draft_page.wiki.should == wiki
    end

    context "when changing the title and text" do

      it "creates a draft page with the same text as the current page" do
        page = create(:page, wiki: wiki, text: "FOO!")
        draft_page = page.find_or_create_draft_page_for_user(user)
        draft_page.text.should == "FOO!"
      end

      it "creates a draft page with the same title as the current page" do
        page = create(:page, wiki: wiki, title: "BAR!")
        draft_page = page.find_or_create_draft_page_for_user(user)
        draft_page.title.should == "BAR!"
      end

      it "doesn't change the title if a draft already exists" do
        page = create(:page, wiki: wiki, title: "Foo")
        draft_page = page.find_or_create_draft_page_for_user(user)
        draft_page.update(title: "Bar")
        page.find_or_create_draft_page_for_user(user).title.should == "Bar"
      end

      it "creates a draft page with the same title as the current page" do
        page = create(:page, wiki: wiki, text: "Foo")
        draft_page = page.find_or_create_draft_page_for_user(user)
        draft_page.update(text: "Bar")
        page.find_or_create_draft_page_for_user(user).text.should == "Bar"
      end

    end

    it "doesn't create multiple draft pages for the same user" do
      page = create(:page, wiki: wiki)
      expect {
        5.times { page.find_or_create_draft_page_for_user(user) }
      }.to change { DraftPage.count }.by(1)
    end

    it "creates multiple draft pages for different users" do
      page = create(:page, wiki: wiki)
      expect {
        5.times { page.find_or_create_draft_page_for_user(create(:active_user)) }
      }.to change { DraftPage.count }.by(5)
    end

    it "returns the existing draft page if one already exists" do
      page = create(:page, wiki: wiki)
      draft_page = page.find_or_create_draft_page_for_user(user)
      page.find_or_create_draft_page_for_user(user).should == draft_page
    end
  end

  context "#update_destroying_draft_pages_for_user" do
    let(:wiki) { create(:wiki) }
    let(:user) { create(:active_user, wiki: wiki) }

    it "updates the page" do
      page = create(:page, wiki: wiki, user: user)
      page.update_destroying_draft_pages_for_user({title: "Foo!"}, user)
      page.reload.title.should == "Foo!"
    end

    context "when destroying draft pages" do
      it "destroys draft pages belonging to the user" do
        page = create(:page, wiki: wiki, user: user)
        draft_page = create(:draft_page, user_id: user.id, wiki_id: wiki.id, page: page)
        page.update_destroying_draft_pages_for_user({title: "Foo!"}, user)
        expect { draft_page.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "doesn't destroy draft pages belonging to a different page" do
        page = create(:page, wiki: wiki, user: user)
        draft_page = create(:draft_page, user_id: user.id, wiki_id: wiki.id, page: create(:page))
        page.update_destroying_draft_pages_for_user({title: "Foo!"}, user)
        expect { draft_page.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
      end

      it "doesn't destroy draft pages belonging to a different user" do
        page = create(:page, wiki: wiki, user: user)
        draft_page = create(:draft_page, user: create(:active_user), wiki_id: wiki.id, page: page)
        page.update_destroying_draft_pages_for_user({title: "Foo!"}, user)
        expect { draft_page.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
      end

      it "doesn't destroy draft pages belonging to another wiki" do
        page = create(:page, wiki: wiki, user: user)
        draft_page = create(:draft_page, user_id: user.id, wiki: create(:wiki), page: page)
        page.update_destroying_draft_pages_for_user({title: "Foo!"}, user)
        expect { draft_page.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
      end

      it "doesn't destroy draft pages if the update fails" do
        page = create(:page, wiki: wiki, user: user)
        draft_page = create(:draft_page, user_id: user.id, wiki_id: wiki.id, page: page)
        page.update_destroying_draft_pages_for_user({title: nil}, user)
        expect { draft_page.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
