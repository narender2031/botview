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
    message_params = {}
    payload= ''
    data['message'].each do |message|
      message_params["content"] = message['message']
      message_params["message_by"] = message['message_by']
      message_params["conversation_id"] = message['conversation_id']
      payload = message['payload']
    end
    Message.create(message_params)
    call_back_to_bot(message_params['content'], current_user.id, message_params['conversation_id'], payload)
  end

  private


  # def call_back_to_bot(message, user_id, conversation_id, payload)
  #   if conversation_id.present? && user_id.present? && message.present?
  #     url = URI("#{ENV['BOT_URL']}")
  #     http = Net::HTTP.new(url.host, url.port)
  #     http.use_ssl = true
  #     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  #     request = Net::HTTP::Post.new(url)
  #     request["content-type"] = 'application/x-www-form-urlencoded'
  #     request.body = "value=#{message}&encounter_id=#{user_id}&payload=#{payload}"
  #     response = http.request(request)
  #   end
  # end
end
