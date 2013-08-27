class UserInvitation < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :code

  def self.create_with_random_code
    UserInvitation.create(code: SecureRandom.hex)
  end
end
