class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
  
    # protect_from_forgery
    include Pundit

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    # if user is logged in, return current_user, else return guest_user
    def current_or_guest_user
        if current_user
            
        if session[:guest_user_id] && session[:guest_user_id] != current_user.id
            logging_in
            # reload guest_user to prevent caching problems before destruction
            guest_user(with_retry = false).try(:reload).try(:destroy)
            session[:guest_user_id] = nil
        end
        current_user
        else
        guest_user
        end
    end

    # find guest_user object associated with the current session,
    # creating one as needed
    def guest_user(with_retry = true)
        # Cache the value the first time it's gotten.
        @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

    rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
        session[:guest_user_id] = nil
        guest_user if with_retry
    end

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
  

    private
    # called (once) when the user logs in, insert any code your application needs
    # to hand off from guest_user to current_user.
    def logging_in
        # @user = params[:user] ? User.new(params[:user]) : create_guest_user
        # if @user.save
        #     current_user.move_to(@user)
        #   session[:guest_user_id] = @user.id
        #   redirect_to root_url
        #   puts params
        # else
        #   render "new"
        # end
        # For example:
        # guest_comments = guest_user.comments.all
        # guest_comments.each do |comment|
        # comment.user_id = current_user.id
        # comment.save!
        # end
    end

    def create_guest_user
      u = User.new(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com", guest: true)
      u.save!(:validate => false)
      session[:guest_user_id] = u.id
      u
    end


end
