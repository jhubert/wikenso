class PendingUserDecorator < Draper::Decorator
  delegate_all

  def invitation_link
    h.redeem_invitation_code_url(invitation_code: model.invitation_code, subdomain: model.wiki_subdomain)
  end

  def status_in_words
    "Invitation sent"
  end
end
