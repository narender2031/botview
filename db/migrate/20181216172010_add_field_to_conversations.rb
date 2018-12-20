class AddFieldToConversations < ActiveRecord::Migration[5.2]
  def change
    add_column :conversations, :bot_type, :string 
  end
end
