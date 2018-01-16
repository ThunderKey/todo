require 'rails_helper'

RSpec.describe TodoList do
  let(:user) { create :user }

  let(:todo_lists) { user.reload.todo_lists }

  context :update_position! do
    before do
      10.times do
        create :todo_list, user: user
      end
    end

    it 'updates all positions after the moved list' do
      expect(todo_lists.sorted.map &:id).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      expect(todo_lists.sorted.map &:position).to eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

      touched_ids = []

      TodoList.after_save { touched_ids << id }

      to_move = todo_lists.find 5
      move_after = todo_lists.find 8

      old_attributes = to_move.attributes.dup

      to_move.update_position! move_after

      expect(todo_lists.sorted.map &:id).to eq [1, 2, 3, 4, 6, 7, 8, 5, 9, 10]
      expect(todo_lists.sorted.map &:position).to eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

      expect(touched_ids).to eq [6, 7, 8, 5]

      expect(to_move.reload.attributes).to_not eq old_attributes
    end

    it 'updates all positions before the moved list' do
      expect(todo_lists.sorted.map &:id).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      expect(todo_lists.sorted.map &:position).to eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

      touched_ids = []

      TodoList.after_save { touched_ids << id }

      to_move = todo_lists.find 6
      move_after = todo_lists.find 2

      old_attributes = to_move.attributes.dup

      to_move.update_position! move_after

      expect(todo_lists.sorted.map &:id).to eq [1, 2, 6, 3, 4, 5, 7, 8, 9, 10]
      expect(todo_lists.sorted.map &:position).to eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

      expect(touched_ids).to eq [3, 4, 5, 6]

      expect(to_move.reload.attributes).to_not eq old_attributes
    end

    it 'saves the position but changes nothing if its inserted at the same position' do
      expect(todo_lists.sorted.map &:id).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      expect(todo_lists.sorted.map &:position).to eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

      touched_ids = []

      TodoList.after_save { touched_ids << id }

      to_move = todo_lists.find 6
      move_after = todo_lists.find 5

      old_attributes = to_move.attributes.dup

      to_move.update_position! move_after

      expect(todo_lists.sorted.map &:id).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      expect(todo_lists.sorted.map &:position).to eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

      expect(touched_ids).to eq [6]

      expect(to_move.reload.attributes).to eq old_attributes
    end
  end
end
