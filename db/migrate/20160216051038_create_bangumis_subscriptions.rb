class CreateBangumisSubscriptions < ActiveRecord::Migration
  def change
    create_table :bangumis_subscriptions do |t|
      t.belongs_to :subscription
      t.belongs_to :bangumi
    end
  end
end
