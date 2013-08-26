class UsersController < ApplicationController
  def index
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
    @users = @wiki.users
  end

  def create
    pending_user = PendingUser.new(user_params)
    if pending_user.save
      redirect_to users_path
    else
      render :index, :status => :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
