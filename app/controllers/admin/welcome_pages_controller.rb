class Admin::WelcomePagesController < ApplicationController
  def new
    @existing_welcome_page = WelcomePage.latest
    @welcome_page = WelcomePage.new
  end

  def create
    welcome_page = WelcomePage.new(welcome_page_params)
    if welcome_page.save
      redirect_to admin_statistics_path, notice: "Successfully saved the welcome page"
    else
      @welcome_page = welcome_page
      flash.now[:error] =  "There was a problem saving your welcome page"
      render :new
    end
  end

  private

  def welcome_page_params
    params.require(:welcome_page).permit(:text, :title)
  end
end
