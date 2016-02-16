class AddLastViewedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_viewed_at, :datetime, default: DateTime.now
  end
end
