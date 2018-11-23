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
        requires :message, type:String, documentation: {in: 'body'}
        requires :user_id, type:Integer
        requires :message_type, type:String
        optional :buttons, type: Array
      end
      post '/results' do
        conversation = Conversation.find_by(sender_id: ENV['BOT_USER_id'], recipient_id: params[:user_id])
        if !conversation.present?
          conversation = Conversation.new(sender_id: ENV['BOT_USER_id'], recipient_id: params[:user_id])
          conversation.save
        end

        message = Message.new(content: params[:message], conversation_id: conversation.id, message_by: "#{ENV['BOT_USER']}", message_type: "text")
        message.save

        if params[:buttons].present?
          Message.create!(content: params[:buttons], message_type: "buttons", conversation_id: conversation.id, message_by: "#{ENV['BOT_USER']}")
        end
        puts "message: #{params[:message]}, user_id: #{params[:user_id]}, message_type: #{params[:message_type]}"
        ({message: params[:message] })
      end
    end
  end
end
