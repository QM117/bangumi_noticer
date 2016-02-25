class AddLastViewedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_viewed_at, :datetime, default: DateTime.parse('2000-01-01')
  end
end
