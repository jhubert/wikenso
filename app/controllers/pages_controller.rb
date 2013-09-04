class PagesController < ApplicationController
  before_filter :authenticate_user!

  def new
    wiki = current_wiki
    @page = wiki.pages.new
  end

  def create
    wiki = current_wiki
    page = wiki.pages.new(creation_page_params.merge(user_id: current_user.id))
    if page.save
      flash[:notice] = t("pages.create.successful_flash")
      redirect_to page_path(page)
    else
      @page = page
      flash.now[:error] = t("pages.create.error_flash")
      render :new
    end
  end

  def edit
    wiki = current_wiki
    @page = wiki.pages.friendly.find(params[:id]).decorate
    @draft_page = @page.find_or_create_draft_page_for_user(current_user).decorate
  end

  def show
    @wiki = current_wiki
    if params.has_key?(:id)
      @page = @wiki.pages.friendly.find(params[:id]).decorate
    else
      @page = @wiki.pages.order("created_at").first.try(:decorate)
    end
  end

  def update
    wiki = current_wiki
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

  def destroy
    page = Page.find_by_slug(params[:id])
    if page
      page.destroy
      flash[:notice] = t("pages.destroy.successful_flash")
      redirect_to root_path
    else
      raise ActionController::RoutingError.new("Not Found")
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
