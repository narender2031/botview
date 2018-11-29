class CreatePasswordController < ApplicationController
    
    def index
        @user = current_or_guest_user
    end

    def create
        user = current_or_guest_user
        if user.present?
          if user.update(password: params['user']['password'], guest: false, role: 'admin')
            session[:guest_user_id] = nil
            user.reload
            sign_out(user)
            sign_in(user)
            redirect_to root_path
          end
        end
    end

    def update_session
        user = current_or_guest_user
        user.reload
        sign_out(user)
        sign_in(user)
        redirect_to root_path
    end
end
