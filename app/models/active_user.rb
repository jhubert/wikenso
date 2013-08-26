class ActiveUser < User
  has_secure_password

  validates_presence_of :name
end