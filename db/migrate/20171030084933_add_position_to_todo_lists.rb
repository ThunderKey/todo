class AddPositionToTodoLists < ActiveRecord::Migration[5.1]
  def change
    add_column :todo_lists, :position, :integer, null: false

    TodoList.all.group_by(&:user_id).each do |user_id, todo_lists|
      todo_lists.each.with_index do |todo_list, pos|
        todo_list.position = pos
        todo_list.save!
      end
    end
  end
end
