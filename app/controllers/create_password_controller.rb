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
            redirect_to user_session_path
          end
        end
    end

    def update_session
        user = current_or_guest_user
        user.reload
        sign_out(user)
        sign_in(user)
        redirect_to user_session_path
    end

    def delete_conversation
        user = current_or_guest_user
        conversation = Conversation.find_by(user_id: user.id)
        Message.where(conversation_id: conversation.id).delete_all
        conversation.delete
        user.delete
        redirect_to user_session_path
    end

end
