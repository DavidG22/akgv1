class ChangeTempTableColumn < ActiveRecord::Migration
 	def self.up
	    change_table :temp_tables do |t|
	      t.change :phone, :string
	    end
  	end
end
