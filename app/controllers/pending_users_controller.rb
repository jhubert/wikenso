class PendingUsersController < ApplicationController
  before_filter :authenticate_user!

  def edit
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    @user = PendingUser.find_by_invitation_code_and_wiki_id(params[:invitation_code], wiki.id)
    render(nothing: true, status: :bad_request) unless @user
  end

  def create
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    pending_user = @wiki.create_pending_user(user_params[:email])
    if pending_user.errors.empty?
      flash[:notice] = t("users.create.successful", wiki_name: @wiki.subdomain, user_email: pending_user.email)
      redirect_to users_path
    else
      flash.now[:error] = pending_user.errors.full_messages
      render("users/index", subdomain: request.subdomain, status: :bad_request)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
