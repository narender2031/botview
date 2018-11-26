class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    user_id = message.conversation.user_id
    bot_id = message.conversation.bot_id
   
    user = User.find(user_id)
    bot = User.find(bot_id)
    broadcast_to_sender(user, message)
    broadcast_to_recipient(bot, message)
  end

  private

  def broadcast_to_sender(user, message)
    if user.name != 'bot'
      ActionCable.server.broadcast(
        "conversations-#{user.id}",
        message:  message.body,
        conversation_id: message.conversation_id,
        message_by: message.message_by, 
        user: user.id,
        # conversation_id: message.conversation_id
      )
    end
  end

  def broadcast_to_recipient(user, message)
    if user.name != 'bot'
      ActionCable.server.broadcast(
        "conversations-#{user.id}",
        message:  message.body,
        conversation_id: message.conversation_id,
        message_by: message.message_by, 
        user: user.id,

        # conversation_id: message.conversation_id
      )
    end
  end

  # def render_message(message, user)
  #   if user.name != "bot"
  #     ApplicationController.render(
  #       partial: 'chat/message_content',
  #       locals: { message: message, user: user }
  #     )
  #   end
  # end

  # def render_window(conversation, user)
  #   ApplicationController.render(
  #     partial: 'conversations/conversation',
  #     locals: { conversation: conversation, user: user }
  #   )
  # end
end  
