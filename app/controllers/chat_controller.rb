class ChatController < ApplicationController
    before_action :authenticate_user!
    require 'uri'
    require 'net/http'
    
    def index
        conversation_ids = get_conversation_ids(current_user.id, 3)
        @messages = Message.where(:conversation_id => conversation_ids.to_a)
    end

    def message
        conversation_id = create_or_check_conversation(params[:sender_id], params[:recipient_id])
        if conversation_id.present?
            message = Message.create!(content: params[:message], conversation_id: conversation_id, message_by: 'user')
            url = URI("https://57a01cb4.ngrok.io/incoming/sarah")
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            request = Net::HTTP::Post.new(url)
            request["content-type"] = 'application/x-www-form-urlencoded'
            request.body = "value=#{params[:message]}&encounter_id=#{params[:sender_id]}"
            response = http.request(request)
            ({message: "#{response} MAnu"})
            conversation_ids = get_conversation_ids(params[:sender_id], params[:recipient_id])
            @messages = Message.where(:conversation_id => conversation_ids.to_a)
            respond_to do |format|
                format.js { render 'message.js.erb' }
            end
        end

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
end
