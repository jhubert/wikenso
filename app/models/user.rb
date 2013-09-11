class User < ActiveRecord::Base
  module Roles
    NormalUser = "user"
    SuperAdminUser = "super_admin"
  end

  belongs_to :wiki
  has_many :pages
  has_many :draft_pages

  validates_uniqueness_of :email, scope: :wiki_id, case_sensitive: false
  validates_presence_of :email
  validates_format_of :email, with: /@/
  validates_inclusion_of :role, in: [Roles::NormalUser, Roles::SuperAdminUser]

  scope :active, -> { where(type: 'ActiveUser') }
  scope :pending, -> { where(type: 'PendingUser') }

  delegate :name, to: :wiki, prefix: true
  delegate :subdomain, to: :wiki, prefix: true

  def super_admin?
    role == Roles::SuperAdminUser
  end
end
