class CreateServiceMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :service_messages do |t|
      t.integer :user_id
      t.string :message
      t.timestamps
    end
  end
end
