class PagesController < ApplicationController
  before_filter :authenticate_user!

  def new
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    @page = wiki.pages.new
  end

  def edit
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
    @page = wiki.pages.friendly.find(params[:id]).decorate
  end

  def show
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
    if params.has_key?(:id)
      @page = @wiki.pages.friendly.find(params[:id]).decorate
    else
      @page = @wiki.pages.order("created_at").first.decorate
    end
  end
end
