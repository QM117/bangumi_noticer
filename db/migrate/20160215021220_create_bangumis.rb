class CreateBangumis < ActiveRecord::Migration
  def change
    create_table :bangumis do |t|
      t.string :title, null: false
      t.string :classfication, null: false
      t.string :magnet_link
      t.datetime :upload_at
      t.string :fansub
      t.string :size

      t.index :title
      t.index :classfication
      t.index [:classfication, :title], unique: true

      t.timestamps
    end
  end
end
