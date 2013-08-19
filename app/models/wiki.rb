class Wiki < ActiveRecord::Base
  validates_uniqueness_of :subdomain, case_sensitive: false
  scope :case_insensitive_find_by_subdomain, lambda {|subdomain| where("lower(subdomain) = ?", subdomain.downcase) }
  has_many :users
  validates_associated :users
  accepts_nested_attributes_for :users
end
