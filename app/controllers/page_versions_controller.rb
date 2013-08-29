class PageVersionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    @page = wiki.pages.friendly.find(params[:page_id])
    @page_versions = PageVersionDecorator.decorate_collection(@page.versions.order("created_at DESC"))
  end
end
