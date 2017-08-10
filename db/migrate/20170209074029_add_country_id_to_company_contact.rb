class AddCountryIdToCompanyContact < ActiveRecord::Migration
  def change
    add_column :company_contacts, :country_id, :integer, references: :countries
  end
end
