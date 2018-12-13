class CreatePasswordController < ApplicationController

  def update_session
    user = current_or_guest_user
    user.reload
    sign_out(user)
    sign_in(user)
    redirect_to root_path, :notice => "Welcome!"
  end

  def delete_conversation
    user = current_or_guest_user
    conversation = Conversation.find_by(user_id: user.id)
    Message.where(conversation_id: conversation.id).delete_all
    conversation.delete
    user.delete
    redirect_to chat_path, :notice => "All conversation is deleted and your information is deleted! For chat again refresh page or click on"
  end

  def update_user
    redirect_to root_path
  end

end
