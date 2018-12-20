class ChatController < ApplicationController
  
  def chat
    cookies[:user_name] = "david"
    current_or_guest_user.reload
    @conversation_id = Conversation.get_conversation(current_or_guest_user.id, ENV['BOT_USER_id'], 'registeration_bot').to_i
    conversation_ids = get_conversation_ids(current_or_guest_user.id, ENV['BOT_USER_id'], 'registeration_bot')
    @messages = Message.where(:conversation_id => conversation_ids.to_a).order(created_at: :asc) if conversation_ids.present?
    puts cookies[:user_name]
  end

  def document_chat
    session[:chat_bot] = ''
    session[:chat_bot] = 'document_bot'
    current_or_guest_user.reload
    @conversation_id = Conversation.get_conversation(current_or_guest_user.id, ENV['BOT_USER_id'], 'document_bot').to_i
    conversation_ids = get_conversation_ids(current_or_guest_user.id, ENV['BOT_USER_id'], 'document_bot')
    @messages = Message.where(:conversation_id => conversation_ids.to_a).order(created_at: :asc) if conversation_ids.present?  
  end

  private
 
  def get_conversation_ids(user_id, bot_id, bot_type)
    user_id = user_id.to_i
    bot_id = bot_id.to_i
    Conversation.where(user_id: user_id, bot_id: bot_id, bot_type: bot_type ).or(Conversation.where(user_id: bot_id, bot_id: user_id, bot_type: bot_type)).pluck(:id)
  end

end
