class DraftPagesController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    wiki = current_wiki
    draft_page = wiki.draft_pages.find_by_id_and_user_id(params[:id], current_user.id)
    if draft_page
      draft_page.destroy
      flash[:notice] = t("draft_pages.destroy.successful_flash")
      redirect_to root_path
    else
      flash[:error] = t("draft_pages.destroy.error_flash")
      render nothing: true, status: :bad_request
    end
  end
end
