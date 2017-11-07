class DashboardController < ApplicationController
  def index
    todo_lists = current_user.todo_lists.active.sorted
    @grouped_todo_lists = {
      past: todo_lists.where('planned_at < ?', Time.zone.now.beginning_of_day),
      current: todo_lists.where('planned_at >= ? AND planned_at < ?', Time.zone.now.beginning_of_day, Time.zone.now.end_of_day),
      not_planned: todo_lists.where(planned_at: nil),
    }
    @grouped_todo_lists.delete(:past) if @grouped_todo_lists[:past].empty?
  end
end
