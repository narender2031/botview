class CreateBotServiceMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :bot_service_messages do |t|
      t.references :service_message, foreign_key: true
      t.references :bot, foreign_key: true

      t.timestamps
    end
  end
end
