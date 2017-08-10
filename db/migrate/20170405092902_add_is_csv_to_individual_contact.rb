class AddIsCsvToIndividualContact < ActiveRecord::Migration
  def change
    add_column :individual_contacts, :is_csv, :boolean, :default => false
  end
end
