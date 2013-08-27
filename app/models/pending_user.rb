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

  def self.find_by_invitation_code_and_wiki_id(invitation_code, wiki_id)
    joins(:invitations).where("user_invitations.code = ? AND users.wiki_id = ?", invitation_code, wiki_id).first
  end

  def invitation_code
    invitations.last.code
  end

  def activate_with_params(params)
    transaction do
      assign_attributes(params) # Need to do this so that the "Password confirmation can't be blank" error doesn't show up
      update_attributes(type: "ActiveUser")
      active_user = becomes(ActiveUser)
      if active_user.update_attributes(params)
        active_user
      else
        raise ActiveRecord::Rollback
      end
    end
  end
end