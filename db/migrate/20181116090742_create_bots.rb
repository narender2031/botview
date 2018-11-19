class CreateBots < ActiveRecord::Migration[5.2]
  def change
    create_table :bots do |t|
      t.string :messages
      t.integer :user_id
      t.timestamps
    end
  end
end
