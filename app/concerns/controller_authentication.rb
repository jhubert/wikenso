module ControllerAuthentication
  extend ActiveSupport::Concern

  included do
    def sign_in(user)
      session[:user_id] = user.id
    end

    def current_user
      User.find_by_id(session[:user_id])
    end

    def user_signed_in?
      session[:user_id].present?
    end
  end
end