class PendingUser < User
  has_many :invitations, class_name: UserInvitation, foreign_key: :user_id

  def self.create_with_invitation(user_params)
    user = PendingUser.new(user_params)
    transaction do
      if user.save
        user.invitations.create_with_random_code
      else
        raise ActiveRecord::Rollback
      end
    end
    user
  end
end