class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :wiki
  has_many :draft_pages

  validates_presence_of :title

  def find_or_create_draft_page_for_user(user)
    draft_pages_for_user(user).first_or_create(text: self.text, title: self.title)
  end

  def update_destroying_draft_pages_for_user(params, user)
    transaction { draft_pages_for_user(user).destroy_all if update(params) }
  end

  private

  def draft_pages_for_user(user)
    draft_pages.where(user_id: user.id, wiki_id: self.wiki.id)
  end
end
