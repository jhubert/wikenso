class Api::V1::DraftPagesController < ApplicationController
  before_filter :authenticate_user!
  include ControllerAuthentication

  def update
    draft_page = current_user.draft_pages.find(params[:id])
    if draft_page.update(draft_page_params)
      render json: {}
    else
      render json: draft_page.errors, status: :bad_request
    end
  end

  private

  def draft_page_params
    params.require(:draft_page).permit(:text, :title)
  end
end
