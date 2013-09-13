class DemoWikiSessionsController < ApplicationController
  def create
    wiki = Wiki.demo_wiki
    sign_in(wiki.users.first)
    redirect_to root_url(subdomain: wiki.subdomain)
  end
end
