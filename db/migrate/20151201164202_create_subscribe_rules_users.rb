class CreateSubscribeRulesUsers < ActiveRecord::Migration
  def change
    create_table :subscribe_rules_users do |t|
    	t.integer :user_id
    	t.integer :subscribe_rule_id
    	t.index [:user_id, :subscribe_rule_id], unique: true
    end
  end
end
