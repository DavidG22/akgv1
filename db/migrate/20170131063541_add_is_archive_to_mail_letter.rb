class AddIsArchiveToMailLetter < ActiveRecord::Migration
  def change
    add_column :mail_letters, :is_archived, :boolean, :default => false
  end
end
