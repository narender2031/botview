
class Chat::GenrateMessage
  attr_reader :messages, :message_template
  def initialize(message)
    @messages = message
    @message_template = {'message' => {}, 'payload' => '', 'type' => ''}
  end

  def perform
    messages['message'].each do |message|
      message_template["message"]["body"] = message['body']
      message_template["message"]["message_by"] = message['message_by']
      message_template["message"]["conversation_id"] = message['conversation_id']
      message_template["payload"] = message['payload']
      message_template["type"] = message['type']
      message_template["bot_type"] = message["chat_bot_type"]
    end
    return message_template
  end
end
