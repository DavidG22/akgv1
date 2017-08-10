class CreateDailyUpdates < ActiveRecord::Migration
  def change
    create_table :daily_updates do |t|
      t.references :deal
      t.string :user_ids
      t.time :alert_time
      t.string :time_zone
      t.string :frequency

      t.timestamps
    end
    add_index :daily_updates, :deal_id
  end
end
