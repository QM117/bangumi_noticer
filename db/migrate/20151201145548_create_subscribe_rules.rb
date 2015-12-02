class CreateSubscribeRules < ActiveRecord::Migration
  def change
    create_table :subscribe_rules do |t|
 			t.string :name
 			t.string :rule

      t.timestamps
    end
    add_index :subscribe_rules, :name, unique: true
  end
end
