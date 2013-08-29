class WikisController < ApplicationController

  def new
    @wiki = Wiki.new
    @wiki.users.new
  end

  def create
    @wiki = Wiki.build_with_active_user(wiki_params)
    if @wiki.save
      sign_in(@wiki.users.first)
      redirect_to root_url(subdomain: @wiki.subdomain)
    else
      flash.now[:error] = t("wikis.create.error_flash")
      render :new
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:subdomain, :users_attributes => [:name, :password, :password_confirmation, :email])
  end
end
