class PendingUsersController < ApplicationController
  def edit
    wiki = Wiki.case_insensitive_find_by_subdomain(request.subdomain).first
    @user = PendingUser.find_by_invitation_code_and_wiki_id(params[:invitation_code], wiki.id)
    render(nothing: true, status: :bad_request) unless @user
  end
end
