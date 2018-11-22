class ChatController < ApplicationController
    before_action :authenticate_user!
    require 'uri'
    require 'net/http'

    def index
        @conversation_id = create_or_check_conversation(current_user.id, ENV['BOT_USER_id']).to_i
        conversation_ids = get_conversation_ids(current_user.id, ENV['BOT_USER_id'])
        @messages = Message.where(:conversation_id => conversation_ids.to_a).order(created_at: :asc) if conversation_ids.present?

    end
    private

    def create_or_check_conversation(sender_id, recipient_id)
        @conversation = Conversation.find_by(sender_id: sender_id.to_i, recipient_id: recipient_id.to_i)
        return @conversation.id if @conversation.present?
        @conversation = Conversation.new(sender_id: sender_id.to_i, recipient_id: recipient_id.to_i)
        return @conversation.id if @conversation.save
    end

    def get_conversation_ids(sender_id, recipient_id)
        sender_id = sender_id.to_i
        recipient_id = recipient_id.to_i
        Conversation.where(sender_id: sender_id, recipient_id: recipient_id).or(Conversation.where(sender_id: recipient_id, recipient_id: sender_id)).pluck(:id)
    end

    # def say_hello_from_bot(user_id)
    #     message = "Hello"
    #     url = URI("https://57a01cb4.ngrok.io/incoming/sarah")
    #     http = Net::HTTP.new(url.host, url.port)
    #     http.use_ssl = true
    #     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #     request = Net::HTTP::Post.new(url)
    #     request["content-type"] = 'application/x-www-form-urlencoded'
    #     request.body = "value=#{message}&encounter_id=#{user_id}"
    #     response = http.request(request)
    # end
end
