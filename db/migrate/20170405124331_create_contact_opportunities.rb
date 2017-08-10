class CreateContactOpportunities < ActiveRecord::Migration
  def change
    create_table :contact_opportunities do |t|
      t.string :opportunity
      t.integer :individual_contact_id
      t.integer :deal_id
      t.boolean :is_converted, :default => false

      t.timestamps
    end
  end
end
