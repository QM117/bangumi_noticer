class AddFansubIdColumnToBangumis < ActiveRecord::Migration
  def change
    add_column :bangumis, :fansub_id, :integer
  end
end
