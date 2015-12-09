class CreateSubscriptionsUsers < ActiveRecord::Migration
  def change
    create_table :subscriptions_users do |t|
    	t.integer :user_id
    	t.integer :subscription_id
    	t.index [:user_id, :subscription_id], unique: true
    end
  end
end
