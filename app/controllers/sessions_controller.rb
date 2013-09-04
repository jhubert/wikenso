class SessionsController < ApplicationController
  include ControllerAuthentication

  def new
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    @user = wiki.users.new.decorate
  end

  def create
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
    user = wiki.users.active.find_by_email(user_params[:email])
      logger.fatal '*' * 50
      logger.fatal params[:remember_me]
    if user && user.authenticate(user_params[:password])
      user_remember_me? ? sign_in_permanently(user) : sign_in(user)
      redirect_to root_url(subdomain: request.subdomain)
    else
      @user = wiki.users.new(user_params).decorate
      flash.now[:error] = I18n.t("sessions.create.sign_in_unsuccessful")
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_url(subdomain: request.subdomain)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def user_remember_me?
    params[:user][:remember_me] == "1"
  end
end
