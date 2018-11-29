require 'grape-swagger'
module ChatApi
  class Chat < Grape::API
    default_format :json
    # authantication methods in helpers
    helpers do
      def authenticate
        token = headers['Authorization']
        User.exists?(token: token)
        if User.exists?(token: token)
          @current_user = User.find_by(token: token)
        else
          error! 'Unauthorized', 401
        end
      end
      def current_user
        @current_user
      end
    end
    # api's
    resource :graph do
      desc "Results"
      params do
        requires :user_id, type:Integer, documentation: {in: 'body'}
        requires :message, type:JSON
      end
      post '/results' do
        conversation_id = Conversation.get_conversation(params['user_id'], ENV['BOT_USER_id']).to_i if params['user_id'].present?
        message = Message.new(body: {content: params['message'], type: '', meta: {}}, conversation_id: conversation_id, message_by: "#{ENV['BOT_USER']}") if params['message'].present?
        if message.save
          ({success: "message is saved"})
        else
          error!({error: "message is not saved!"}, 400)
        end
      end
    end
  end
end
