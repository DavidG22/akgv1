class AddIsKanbanToDealStatus < ActiveRecord::Migration
  def change
    add_column :deal_statuses, :is_kanban, :boolean, default: false
  end
end
