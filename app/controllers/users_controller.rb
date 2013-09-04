class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @wiki = current_wiki
  end
end
