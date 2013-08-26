class UsersController < ApplicationController
  def index
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
    @users = @wiki.users
  end
end
