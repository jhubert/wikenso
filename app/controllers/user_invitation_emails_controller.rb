class UserInvitationEmailsController < ApplicationController
  def create
    user = PendingUser.find_by_id(params[:user_id])
    if user
      UserMailer.invitation_mail(user, user.wiki).deliver
      flash[:notice] = t("user_invitation_emails.create.successful_flash", email: user.email)
    else
      flash[:error] = [t("user_invitation_emails.create.error_flash")]
    end
    redirect_to users_path(subdomain: request.subdomain)
  end
end
