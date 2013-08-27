class PendingUserDecorator < Draper::Decorator
  delegate_all

  def invitation_link
    h.redeem_invitation_code_url(invitation_code: model.invitation_code, subdomain: model.wiki_subdomain)
  end

  def status_for_table
    resend_link = h.link_to("(Resend)", h.resend_invitation_email_path(user_id: model.id), class: "wiki-users-table-invitation-resend-link", method: :post)
    "Invitation sent #{resend_link}"
  end
end
