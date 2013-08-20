module Api
  module V1
    class PagesController < ApplicationController
      def update
        page = Page.find(params[:id])
        if page.update(page_params)
          render json: page, only: [:title, :text]
        else
          render json: page.errors, status: :bad_request
        end

      end

      private

      def page_params
        params.require(:page).permit(:text, :title)
      end
    end
  end
end