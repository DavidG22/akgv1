class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :title
      t.text :description
      t.datetime :reminder_date
      t.text :email_ids
      t.string :send_before
      t.datetime :sent_at
      t.references :reminder_type
      t.references :deal

      t.timestamps
    end
    add_index :reminders, :reminder_type_id
    add_index :reminders, :deal_id
  end
end
