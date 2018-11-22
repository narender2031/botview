class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    sender_id = message.conversation.sender_id
    recipient_id = message.conversation.recipient_id
   
    sender = User.find(sender_id)
    recipient = User.find(recipient_id)
    broadcast_to_sender(sender, message)
    broadcast_to_recipient(recipient, message)
  end

  private

  def broadcast_to_sender(user, message)
    if message.message_by != "bot"
      ActionCable.server.broadcast(
        "conversations-#{user.id}",
        message: render_message(message, user),
        content: message, 
        user: user.id,
        # conversation_id: message.conversation_id
      )
    end
  end

  def broadcast_to_recipient(user, message)
    if user.name != "bot"
      ActionCable.server.broadcast(
        "conversations-#{user.id}",
        message: render_message(message, user),
        content: message, 
        user: user.id

        # conversation_id: message.conversation_id
      )
    end
  end

  def render_message(message, user)
    if user.name != "bot"
      ApplicationController.render(
        partial: 'chat/message_content',
        locals: { message: message, user: user }
      )
    end
  end

  # def render_window(conversation, user)
  #   ApplicationController.render(
  #     partial: 'conversations/conversation',
  #     locals: { conversation: conversation, user: user }
  #   )
  # end
end  