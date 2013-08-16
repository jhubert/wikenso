class WikisController < ApplicationController
  def new
    @wiki = Wiki.new
  end

  def create
    wiki = Wiki.new(wiki_params)
    if wiki.save
      redirect_to wiki_path(wiki)
    else
      render :new
    end
  end

  def show
    @wiki = Wiki.find_by_name!(request.subdomain)
  end

  private

  def wiki_params
    params.require(:wiki).permit(:name)
  end
end
