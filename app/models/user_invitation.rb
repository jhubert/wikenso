class UserInvitation < ActiveRecord::Base
  belongs_to :user

  def self.create_with_random_code
    UserInvitation.create(code: SecureRandom.hex)
  end
end
