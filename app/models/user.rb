class User < ActiveRecord::Base
  has_secure_password

  belongs_to :wiki
  has_many :pages

  validates_uniqueness_of :email
  validates_presence_of :name, :email
end
