class TodoList < ApplicationRecord
  include ItemColorHelper
  extend ItemColorHelper

  enum color: item_colors

  belongs_to :user
  has_many :items, class_name: 'TodoListItem', dependent: :destroy
end
