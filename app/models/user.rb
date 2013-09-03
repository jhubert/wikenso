class User < ActiveRecord::Base
  belongs_to :wiki
  has_many :pages
  has_many :draft_pages

  validates_uniqueness_of :email, scope: :wiki_id, case_sensitive: false
  validates_presence_of :email
  validates_format_of :email, with: /@/

  scope :active, -> { where(type: 'ActiveUser') }
  scope :pending, -> { where(type: 'PendingUser') }

  delegate :name, to: :wiki, prefix: true
  delegate :subdomain, to: :wiki, prefix: true
end
