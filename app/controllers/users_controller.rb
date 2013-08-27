class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
  end
end
