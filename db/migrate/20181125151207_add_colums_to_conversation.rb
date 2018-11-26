class AddColumsToConversation < ActiveRecord::Migration[5.2]
  def change
    add_column :conversations, :user_id, :integer 
    add_column :conversations, :bot_id, :integer
  end
end
