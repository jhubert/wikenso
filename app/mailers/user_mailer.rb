class UserMailer < ActionMailer::Base
  default from: "Wikenso Robot <robot@wikenso.com>"

  def invitation_mail(user, wiki)
    @user = user.decorate
    @wiki = wiki
    mail(to: @user.email, subject: "You have been invited to join #{wiki.name}")
  end
end
