class ChatController < ApplicationController
  # before_action :authenticate_user!
  
  require 'uri'
  require 'net/http'

  def index
    current_or_guest_user.reload
    @conversation_id = Conversation.get_conversation(current_or_guest_user.id, ENV['BOT_USER_id']).to_i
    conversation_ids = get_conversation_ids(current_or_guest_user.id, ENV['BOT_USER_id'])
    @messages = Message.where(:conversation_id => conversation_ids.to_a).order(created_at: :asc) if conversation_ids.present?

  end
  private
 
  def get_conversation_ids(user_id, bot_id)
    user_id = user_id.to_i
    bot_id = bot_id.to_i
    Conversation.where(user_id: user_id, bot_id: bot_id).or(Conversation.where(user_id: bot_id, bot_id: user_id)).pluck(:id)
  end

end
