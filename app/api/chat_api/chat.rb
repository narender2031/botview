require 'grape-swagger'
module ChatApi
  class Chat < Grape::API
    default_format :json
    # authantication methods in helpers
    helpers do
      def authenticate
        token = headers['Authorization']
        puts token 
        if token == ENV['MESSAGE_SECERT']
          ({success: "done"})
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
      desc "get messages",{
        headers: {
            "Authorization" => {
            description: "Valdates your identity",
            required: true
            }
        }
        }
      params do
        requires :conversation_id, type:Integer, documentation: {in: 'body'}
        requires :message, type:JSON
      end
      post '/results' do
        authenticate
        puts params['message']
        conversation = Conversation.find_by(id: params[:conversation_id])
        if conversation.present?
          message = Message.new(body: {content: params['message'], type: '', meta: {}}, conversation_id: conversation.id, message_by: "#{ENV['BOT_USER']}") if params['message'].present?
          if message.save
            ({success: "message is saved"})
          else
            error!({error: "message is not saved!"}, 400)
          end
        end
      end
    end
  end
end
