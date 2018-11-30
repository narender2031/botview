class SigninController < ApplicationController
    def new
        # sign_in th guest by making it a normal user
        if current_or_guest_user.present?
            user=User.find(current_or_guest_user.id)
            session[:guest_user_id] = nil
            user.reload
            sign_out(user) 
            sign_in(user) #keeps the cuurent user signed in
            redirect_to root_path
        end
    end
end