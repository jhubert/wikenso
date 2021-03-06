class WikisController < ApplicationController

  def new
    @wiki = Wiki.new
    @wiki.users.new
  end

  def create
    @wiki = Wiki.build_with_active_user(wiki_creation_params)
    if @wiki.save_with_seed_page
      sign_in(@wiki.users.first)
      redirect_to root_url(subdomain: @wiki.subdomain)
    else
      flash.now[:error] = t("wikis.create.error_flash")
      render :new
    end
  end

  def edit
    @wiki = current_wiki
  end

  def update
    wiki = current_wiki
    if wiki.update(wiki_updation_params)
      flash[:notice] = t("wikis.update.successful_flash")
      redirect_to root_path
    else
      @wiki = wiki
      flash.now[:error] = t("wikis.update.error_flash")
      render :edit
    end
  end

  private

  def wiki_creation_params
    params.require(:wiki).permit(:subdomain, :users_attributes => [:name, :password, :password_confirmation, :email])
  end

  def wiki_updation_params
    params.require(:wiki).permit(:logo, :name)
  end
end
