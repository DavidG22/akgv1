class AddUserLabelIdToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :user_label_id, :integer, :default => 1
  end
end
