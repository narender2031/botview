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
            redirect_to update_user
          end
        end
    end

    def update_session
        user = current_or_guest_user
        user.reload
        sign_out(user)
        sign_in(user)
        redirect_to update_user, :notice => "Welcome!"
    end

    def delete_conversation
        user = current_or_guest_user
        conversation = Conversation.find_by(user_id: user.id)
        Message.where(conversation_id: conversation.id).delete_all
        conversation.delete
        user.delete
        redirect_to chat_path, :notice => "All conversation is deleted and your information is deleted! to chat again refresh page"
    end

    def update_user
        redirect_to root_path
    end

end
