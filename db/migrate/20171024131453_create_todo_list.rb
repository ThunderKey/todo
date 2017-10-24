class CreateTodoList < ActiveRecord::Migration[5.1]
  def change
    create_table :todo_lists do |t|
      t.string :title
      t.text :description
      t.integer :color, null: false, default: 0
      t.boolean :archived, null: false, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
