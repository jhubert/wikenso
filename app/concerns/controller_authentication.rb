module ControllerAuthentication
  extend ActiveSupport::Concern

  included do
    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out
      session.delete(:user_id)
    end

    def current_user
      User.find_by_id(session[:user_id])
    end

    def user_signed_in?
      session[:user_id].present?
    end

    def authenticate_user!
      if !user_signed_in?
        redirect_to new_session_url(subdomain: request.subdomain)
      end
    end
  end
end