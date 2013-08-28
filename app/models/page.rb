class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :wiki
  has_many :draft_pages

  validates_presence_of :title

  def find_or_create_draft_page_for_user(user)
    draft_page = draft_pages.where(user_id: user.id, wiki_id: self.wiki.id).first_or_initialize
    draft_page.update(text: self.text, title: self.title)
    draft_page
  end
end
