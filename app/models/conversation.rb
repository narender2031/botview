class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :user, foreign_key: :user_id, class_name: 'User'
  belongs_to :bot, foreign_key: :bot_id, class_name: 'User'  
  
  private

  def self.get_conversation(user_id, bot_id, bot_type)
    @conversation = Conversation.find_by(user_id: user_id.to_i, bot_id: bot_id.to_i, bot_type: bot_type)
    return @conversation.id if @conversation.present?
    @conversation = Conversation.new(user_id: user_id.to_i, bot_id: bot_id.to_i, bot_type: bot_type)
    return @conversation.id if @conversation.save
  end
end
