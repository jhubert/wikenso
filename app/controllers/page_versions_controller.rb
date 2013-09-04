class PageVersionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    wiki = current_wiki
    @page = wiki.pages.friendly.find(params[:page_id])
    @page_versions = PageVersionDecorator.decorate_collection(@page.versions.order("created_at DESC"))
  end

  def show
    wiki = current_wiki
    page = wiki.pages.find_by_slug(params[:page_id])
    page_version = page.versions.find_by_id(params[:id]) if page

    if page && page_version
      @page = page.decorate
      @page_version = PageVersionDecorator.new(page_version)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
