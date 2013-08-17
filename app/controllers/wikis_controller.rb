class WikisController < ApplicationController
  include ControllerAuthentication

  def new
    @wiki = Wiki.new
    @wiki.users.new
  end

  def create
    @wiki = Wiki.new(wiki_params)
    if @wiki.save
      sign_in(@wiki.users.first)
      redirect_to root_url(subdomain: @wiki.name)
    else
      render :new
    end
  end

  def show
    @wiki = Wiki.case_insensitive_find_by_name(request.subdomain).first!
  end

  private

  def wiki_params
    params.require(:wiki).permit(:name, :users_attributes => [:name, :password, :password_confirmation])
  end
end
