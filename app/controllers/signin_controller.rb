class SigninController < ApplicationController
    def new
        # sign_in th guest by making it a normal user
        if current_or_guest_user.present?
            user=User.find(current_or_guest_user.id)
            session[:guest_user_id] = nil
            current_or_guest_user.reload
            sign_out(user)
            sign_in(user)
            redirect_to root_path
        end
    end
end