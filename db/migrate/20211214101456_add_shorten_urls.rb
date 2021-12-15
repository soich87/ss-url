class AddShortenUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :shorten_urls, id: false do |t|
      t.bigint :id, null: false, unique: true, primary_key: true
      t.string :url_code, unique: true, null: false
      t.string :origin_url, null: false
      t.datetime :expired_at
      t.bigint :user_id
      t.integer :api_key_id
      t.integer :clicked_count, default: 0
      t.timestamps
    end
  end
end
