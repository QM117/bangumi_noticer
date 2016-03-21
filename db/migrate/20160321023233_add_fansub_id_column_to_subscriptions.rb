class AddFansubIdColumnToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :fansub_id, :integer
    add_index :subscriptions, [:fansub_id, :name]
  end
end
