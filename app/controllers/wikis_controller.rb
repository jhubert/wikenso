class WikisController < ApplicationController

  def new
    @wiki = Wiki.new
    @wiki.users.new
  end

  def create
    @wiki = Wiki.new(wiki_params)
    if @wiki.save
      sign_in(@wiki.users.first)
      redirect_to root_url(subdomain: @wiki.subdomain)
    else
      render :new
    end
  end

  def edit
    @wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first!
  end

  private

  def wiki_params
    params.require(:wiki).permit(:subdomain, :users_attributes => [:name, :password, :password_confirmation, :email])
  end
end
