class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token
      t.integer :user_id
      t.datetime :expires_at
      t.timestamps
    end
    add_index :api_keys, :access_token, unique: true
    add_index :api_keys, :user_id
  end
end
