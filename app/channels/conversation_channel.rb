class ConversationChannel < ApplicationCable::Channel
  require 'uri'
  require 'net/http'


  def subscribed
    stream_from "conversations-#{current_user.id}"
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
    call_back_to_bot(message, current_user.id, message_params['conversation_id'], result['payload'])
  end

  private

  def call_back_to_bot(message, user_id, conversation_id, payload)
    if conversation_id.present? && user_id.present? && message.present?
      url = URI("#{ENV['BOT_URL']}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(url)
      request["content-type"] = 'application/x-www-form-urlencoded'
      request.body = "value=#{message}&encounter_id=#{user_id}&payload=#{payload}"
      response = http.request(request)
      puts response.code
    end
  end
end
