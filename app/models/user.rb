class User < ActiveRecord::Base
  belongs_to :wiki
  has_many :pages

  validates_uniqueness_of :email
  validates_presence_of :email
  validates_format_of :email, with: /@/
end
