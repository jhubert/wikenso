class PagesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
  end
end
