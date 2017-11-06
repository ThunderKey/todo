class AddPlannedAtToTodoLists < ActiveRecord::Migration[5.1]
  def change
    add_column :todo_lists, :planned_at, :datetime
  end
end
