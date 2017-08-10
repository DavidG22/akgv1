class AddCompanyNameToIndividualContacts < ActiveRecord::Migration
  def change
    add_column :individual_contacts, :company_name, :string
    add_column :individual_contacts, :work_phone, :string
  end
end
