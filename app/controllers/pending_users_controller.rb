class PendingUsersController < ApplicationController
  before_filter :authenticate_user!, only: [:create]

  def edit
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    @user = PendingUser.find_by_invitation_code_and_wiki_id(params[:invitation_code], wiki.id)
    @invitation_code = params[:invitation_code]
    render(nothing: true, status: :bad_request) unless @user
  end

  def create
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    pending_user = @wiki.create_pending_user(user_creation_params[:email])
    if pending_user.errors.empty?
      flash[:notice] = t("users.create.successful", wiki_name: @wiki.subdomain, user_email: pending_user.email)
      redirect_to users_path
    else
      flash.now[:error] = pending_user.errors.full_messages
      render("users/index", subdomain: request.subdomain, status: :bad_request)
    end
  end

  def update
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    user = PendingUser.find_by_invitation_code_and_wiki_id(params[:invitation_code], wiki.id)
    active_user = user.activate_with_params(user_updation_params) if user
    if active_user
      sign_in(active_user)
      flash[:notice] = t("pending_users.update.welcome_flash_message", wiki_name: user.wiki_name)
      redirect_to root_path(subdomain: request.subdomain)
    else
      @user = user
      @invitation_code = params[:invitation_code]
      render :edit
    end
  end

  private

  def user_creation_params
    params.require(:user).permit(:email)
  end

  def user_updation_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
