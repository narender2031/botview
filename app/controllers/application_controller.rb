class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    protect_from_forgery
    include Pundit

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private
    def user_not_authorized
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
    end
    

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone_number])
    end

    def after_sign_in_path_for(resource)
        # Here you can write logic based on roles to return different after-sign-in paths
        root_path
      end

end
