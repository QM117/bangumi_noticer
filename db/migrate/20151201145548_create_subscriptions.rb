class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
 			t.string :name
 			t.string :rule

      t.timestamps
    end
    add_index :subscriptions, :name, unique: true
  end
end
