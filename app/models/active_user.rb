class ActiveUser < User
  has_secure_password validations: false

  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  validates_presence_of     :password, unless: lambda { |m| m.password_digest.present? }

  validates_presence_of :name
end