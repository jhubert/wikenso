class PagesController < ApplicationController
  before_filter :authenticate_user!

  def new
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    @page = wiki.pages.new
  end

  def create
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    page = wiki.pages.new(creation_page_params.merge(user_id: current_user.id))
    if page.save
      flash[:notice] = t("pages.create.successful_flash")
      redirect_to page_path(page)
    else
      @page = page
      flash[:error] = t("pages.create.error_flash")
      render :new
    end
  end

  def edit
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
    @page = wiki.pages.friendly.find(params[:id]).decorate
    @draft_page = @page.find_or_create_draft_page_for_user(current_user).decorate
  end

  def show
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
    if params.has_key?(:id)
      @page = @wiki.pages.friendly.find(params[:id]).decorate
    else
      @page = @wiki.pages.order("created_at").first.decorate
    end
  end

  def update
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
    page = wiki.pages.friendly.find(params[:id])
    if page.update_destroying_draft_pages_for_user(updation_page_params, current_user)
      flash[:notice] = t("pages.update.successful_flash")
      redirect_to page_path(page)
    else
      flash.now[:error] = t("pages.update.error_flash")
      @page = page
      @draft_page = page.find_or_create_draft_page_for_user(current_user).decorate
      render :edit
    end
  end

  private

  def creation_page_params
    params.require(:page).permit(:title)
  end

  def updation_page_params
    params.require(:page).permit(:title, :text)
  end
end
