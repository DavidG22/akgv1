class AddCountryIdToIndividualContact < ActiveRecord::Migration
  def change
  	change_column :individual_contacts, :country, :integer
    rename_column :individual_contacts, :country, :country_id
  end
end
