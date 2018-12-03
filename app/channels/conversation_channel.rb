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
    type  = ''
    puts "--------------------"
    puts data
    puts "--------------------"
    data['message'].each do |message|
      message_params["body"] = message['body']
      message_params["message_by"] = message['message_by']
      message_params["conversation_id"] = message['conversation_id']
      payload = message['payload']
      type = message['type']
    end
    message = message_params['body']['content']['text']
    if type == "name"
      User.find(current_user.id).update(name: message)
    end
    if type == 'password'
      User.find(current_user.id).update(password: message, guest: false)
      message_params['body']['content']['text'] = '******************'
    end
    if type == 'email'
      User.find(current_user.id).update(email: message)
    end
    Message.create(message_params)
    call_back_to_bot(message, current_user.id, message_params['conversation_id'], payload)
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
    end
  end


  # def check_email_or_insert_to_deploy(message)
  #   /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(message)
  # end


  # def update_guest_user(email, user_id)
  #   user = User.find(user_id)
  #   if !User.exists?(email: email)
  #     if user.present?
  #       user.update(email: email)
  #     end
  #   else
  #     # message = "Error! this email is already taken" 
  #     # compose_error(message, user)
  #   end
  # end

  # def compose_error(message, user)
    
  # end
end
