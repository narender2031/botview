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
      # byebug
      message_params["body"] = message['body']
      message_params["message_by"] = message['message_by']
      message_params["conversation_id"] = message['conversation_id']
      payload = message['payload']
      Message.create(message_params)
      # byebug
      email_regexp = /\A[^@\s]+@[^@\s]+\z/

      if message['body']['type'] == 'name'
        if message_params['body']['content']['text'] != ' '
          user=User.find(current_user.id).update!(name: message_params['body']['content']['text'], guest: 'false', role: 'admin')
        end
      end

      if message['body']['type'] == 'email'
        if message_params['body']['content']['text'].match?(email_regexp)
          generated_password = Devise.friendly_token.first(8)
          user=User.find(current_user.id).update!(email: message_params['body']['content']['text'], guest: 'false', password: generated_password, password_confirmation: generated_password, role: 'admin')
        end
      end

      if message['body']['type'] == 'password'
        if message_params['body']['content']['text'] !=''
          user=User.find(current_user.id).update!(password: message_params['body']['content']['text'], guest: 'false', role: 'admin')
        end
      end
    end
    call_back_to_bot(message_params['body']['content']['text'], current_user.id, message_params['conversation_id'], payload)
  end

  private


  def call_back_to_bot(message, user_id, conversation_id, payload)
    puts "----------------------------------------------------"
    if conversation_id.present? && user_id.present? && message.present?
      url = URI("#{ENV['BOT_URL']}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(url)
      request["content-type"] = 'application/x-www-form-urlencoded'
      request.body = "value=#{message}&encounter_id=#{user_id}&payload=#{payload}"
      response = http.request(request)
    end
  end
end
