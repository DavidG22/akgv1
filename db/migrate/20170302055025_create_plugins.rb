class CreatePlugins < ActiveRecord::Migration
  def change
    create_table :plugins do |t|
      t.string :name
      t.string :url
      t.boolean :is_active, :default => true

      t.timestamps
    end
  end
end
