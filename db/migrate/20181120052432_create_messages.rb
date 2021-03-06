class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :conversation, foreign_key: true
      t.string :message_by
      t.timestamps
    end
  end
end
