class Chat::SendMessage
  attr_reader :message, :conversation_id, :payload, :bot_type, :user_id

  def initialize(message, conversation_id, payload, bot_type, user_id)
    @message = message
    @conversation_id = conversation_id
    @payload  = payload
    @bot_type = bot_type
    @user_id  = user_id
  end

  def perform
    body = genrate_body
    url = URI("#{ENV['BOT_URL']}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request.body = body.to_json
    response = http.request(request)
    return response.code
  end

  def genrate_body
    body = {
      message: message,
      conversation_id: conversation_id,
      payload: payload,
      meta: {
        user_id: user_id,
        bot_type: bot_type,
        token: ENV['MESSAGE_SECERT']
      }
    }
    return body
  end
end