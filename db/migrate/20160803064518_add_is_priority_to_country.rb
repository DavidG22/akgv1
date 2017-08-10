class AddIsPriorityToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :is_priority, :boolean, :default => false
  end
end
