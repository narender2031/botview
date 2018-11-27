class RemoveColumFromMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :content 
    remove_column :messages, :message_type
  end
end
