class CreateTodoListItem < ActiveRecord::Migration[5.1]
  def change
    create_table :todo_list_items do |t|
      t.text :description, null: false
      t.references :todo_list, foreign_key: true
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
