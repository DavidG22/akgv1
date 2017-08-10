class AddNoteToTempTable < ActiveRecord::Migration
  def change
    add_column :temp_tables, :note, :text
  end
end
