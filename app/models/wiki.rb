class Wiki < ActiveRecord::Base
  validates_uniqueness_of :name, case_sensitive: false
  scope :case_insensitive_find_by_name, lambda {|name| where("lower(name) = ?", name.downcase) }
end
