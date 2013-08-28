require 'spec_helper'

describe Page do
  context ".find_or_create_draft_page_for_user" do
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
  end
end
