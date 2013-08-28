class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :wiki
  has_many :draft_pages

  validates_presence_of :title

  def find_or_create_draft_page_for_user(user)
    draft_pages.create(user_id: user.id, wiki_id: self.wiki.id, text: self.text, title: self.title)
  end
end
