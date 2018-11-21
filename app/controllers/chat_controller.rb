class ChatController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @conversation_id = create_or_check_conversation(current_user.id, 3).to_i
        conversation_ids = get_conversation_ids(current_user.id, 3)
        @messages = Message.where(:conversation_id => conversation_ids.to_a)
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
