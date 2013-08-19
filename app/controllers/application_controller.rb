class ApplicationController < ActionController::Base
  include ControllerAuthentication
  helper_method :current_user, :user_signed_in?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Subdomain
  helper_method :subdomain?

  require_inclusion_of_subdomain in: lambda { Wiki.pluck(:subdomain).map(&:downcase) }
end
