class TodoList < ApplicationRecord
  include ItemColorHelper
  extend ItemColorHelper

  enum color: item_colors

  belongs_to :user
  has_many :items, class_name: 'TodoListItem', dependent: :destroy

  scope :sorted, -> { order :position }
  scope :archived, -> { where archived: true }
  scope :active, -> { where archived: false }

  attr_accessor :skip_position_validation
  validates :position, presence: true, uniqueness: {scope: :user_id}, unless: -> { archived || skip_position_validation }
  validates :title, presence: true

  before_validation(on: :create) do
    unless position
      self.position = (user.todo_lists.pluck(:position).max || -1) + 1
    end
  end

  def update_position! after
    old_position = position
    self.position = after ? after.position + 1 : 0

    if position != old_position
      others = user.todo_lists.sorted
      if old_position > position
        others = others.where(position: (position...old_position))
        others.each do |other|
          other.position += 1
          other.skip_position_validation = true
          other.save!
        end
      else
        self.position -= 1
        others = others.where(position: ((old_position + 1)..position))
        others.each do |other|
          other.position -= 1
          other.skip_position_validation = true
          other.save!
        end
      end
    end
    save!
  end
end
