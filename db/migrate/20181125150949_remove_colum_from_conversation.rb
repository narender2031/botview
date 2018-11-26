class RemoveColumFromConversation < ActiveRecord::Migration[5.2]
  def change
    remove_column :conversations, :sender_id
    remove_column :conversations, :recipient_id
  end
end
