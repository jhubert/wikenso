class UsersController < ApplicationController
  def index
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
  end

  def create
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    pending_user = @wiki.users.pending.new(user_params)
    if pending_user.save
      flash[:notice] = t("users.create.successful", wiki_name: @wiki.subdomain, user_email: pending_user.email)
      redirect_to users_path
    else
      flash.now[:error] = pending_user.errors.full_messages
      render(:index, subdomain: request.subdomain, status: :bad_request)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
