class AddApiSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :api_settings do |t|
      t.string :api_key, null: false, unique: true
      t.integer :remaining_requests, default: 0
      t.integer :user_id
      t.datetime :expired_at

      t.timestamps
    end
  end
end
