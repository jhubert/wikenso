class PagesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
    if params.has_key?(:id)
      @page = @wiki.pages.find_by_id!(params[:id])
    else
      @page = @wiki.pages.order("created_at").first
    end
  end
end
