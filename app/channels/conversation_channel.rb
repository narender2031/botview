class ConversationChannel < ApplicationCable::Channel
  require 'uri'
  require 'net/http'


  def subscribed
    puts params
    
    conversation = Conversation.where(user_id: current_user.id).last
    stream_from "conversations-#{params['conversation_id']}"
  end

  def unsubscribed
    stop_all_streams
  end

  def speak(data)
    message_template = Chat::GenrateMessage.new(data)
    result = message_template.perform
    message_params = result['message']
    message = message_params['body']['content']['text']
    user = User::UpdateUser.new(result['type'], message, current_user.id) if result['type'] == "email" && result['type'] == "name" && result['type'] == "password"
    user.perform if user.present?
    Message.create(message_params)
    call_back_to_bot(message, current_user.id, message_params['conversation_id'], result['payload'], result['bot_type'])
  end

  private
  # bot message schema
  # 1. fields
  # conversation_id, bot_type, message, payload,
  # encounter_id=conversation_id, value=message, payload=payload

  def call_back_to_bot(message, user_id, conversation_id, payload, bot_type)
    if conversation_id.present? && user_id.present? && message.present?
      message = Chat::SendMessage.new(message, conversation_id, payload, bot_type, user_id)
      response = message.perform
      puts response
    end
  end
end
