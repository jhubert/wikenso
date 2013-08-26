class SessionsController < ApplicationController
  include ControllerAuthentication

  def new
    @user = User.new
  end

  def create
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
    user = wiki.users.active.find_by_email(user_params[:email])
    if user && user.authenticate(user_params[:password])
      sign_in(user)
      redirect_to root_url(subdomain: request.subdomain)
    else
      @user = User.new(user_params)
      flash[:error] = I18n.t("sessions.create.sign_in_unsuccessful")
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
end
