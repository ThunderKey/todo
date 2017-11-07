class TodoListsController < ApplicationController
  def index
    @todo_lists = current_user.todo_lists.active.sorted
  end

  def plan
    start_time = Time.zone.now.beginning_of_day
    end_time = 6.days.from_now.end_of_day
    todo_lists = current_user.todo_lists.active.sorted
    @todo_lists_by_date = {
      past: todo_lists.where('planned_at < ?', start_time),
      nil => [],
    }
    @todo_lists_by_date.delete(:past) if @todo_lists_by_date[:past].empty?
    (start_time.to_date..end_time.to_date).each {|d| @todo_lists_by_date[d] = []}
    todo_lists
      .where('planned_at IS NULL OR planned_at BETWEEN ? AND ?', start_time, end_time)
      .each do |todo_list|
      @todo_lists_by_date[todo_list.planned_at&.to_date] << todo_list
    end
  end

  def archived
    @todo_lists = current_user.todo_lists.archived.sorted
  end

  def new
    @todo_list = current_user.todo_lists.new
  end

  def edit
    @todo_list = current_user.todo_lists.find params[:id]
  end

  def create
    @todo_list = current_user.todo_lists.new todo_list_params
    if @todo_list.save
      flash.notice = t 'page.todo_list.created.successful'
      redirect_to todo_lists_path
    else
      render :new
    end
  end

  def update
    @todo_list = current_user.todo_lists.find params[:id]
    @todo_list.update_attributes todo_list_params
    if @todo_list.save
      flash.notice = t 'page.todo_list.updated.successful'
      redirect_to todo_lists_path
    else
      render :edit
    end
  end

  def sort
    @todo_list = current_user.todo_lists.find params[:id]
    after_id = params.permit(:after)[:after]
    after = after_id && current_user.todo_lists.find(after_id)
    @todo_list.transaction do
      if params.has_key? :plannedAt
        planned_at = params.permit(:plannedAt)[:plannedAt]
        if planned_at.blank?
          @todo_list.planned_at = nil
        else
          begin
            @todo_list.planned_at = Time.parse planned_at
          rescue ArgumentError
            render json: {status: 400, error: 'Invalid Date'}, status: 400
            return
          end
        end
      end
      @todo_list.update_position! after
    end
    render json: {status: :success}
  end

  def archive
    @todo_list = current_user.todo_lists.find params[:id]
    if @todo_list.archived
      flash.alert = t 'page.todo_list.archive.already'
    else
      @todo_list.archived = true
      if @todo_list.save
        flash.notice = t 'page.todo_list.archive.successful'
      else
        flash.alert = t 'page.todo_list.archive.failed', errors: @todo_list.errors.full_messages.join(',')
      end
    end
    redirect_back fallback_location: todo_lists_path
  end

  def restore
    @todo_list = current_user.todo_lists.find params[:id]
    if @todo_list.archived
      @todo_list.archived = false
      if @todo_list.save
        flash.notice = t 'page.todo_list.restore.successful'
      else
        flash.alert = t 'page.todo_list.restore.failed', errors: @todo_list.errors.full_messages.join(',')
      end
    else
      flash.alert = t 'page.todo_list.restore.already'
    end
    redirect_back fallback_location: archived_todo_lists_path
  end

  def destroy
    @todo_list = current_user.todo_lists.find params[:id]
    if @todo_list.archived
      @todo_list.destroy
      flash.notice = t 'page.todo_list.destroy.successful'
    else
      flash.alert = t 'page.todo_list.destroy.not_archived'
    end
    redirect_back fallback_location: archived_todo_lists_path
  end

  private

  def todo_list_params
    params.require(:todo_list).permit(:title, :description)
  end
end
