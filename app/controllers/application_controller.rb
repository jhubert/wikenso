class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Subdomain

  require_inclusion_of_subdomain in: lambda { Wiki.pluck(:name).map(&:downcase) }
end
