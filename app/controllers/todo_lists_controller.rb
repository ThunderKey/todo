class TodoListsController < ApplicationController
  def index
    @todo_lists = current_user.todo_lists.active.sorted
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
      flash.notice = 'Todo list created successfully'
      redirect_to todo_lists_path
    else
      render :new
    end
  end

  def update
    @todo_list = current_user.todo_lists.find params[:id]
    @todo_list.update_attributes todo_list_params
    if @todo_list.save
      flash.notice = 'Todo list updated successfully'
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
      @todo_list.update_position! after
    end
    render json: {status: :success}
  end

  def archive
    @todo_list = current_user.todo_lists.find params[:id]
    @todo_list.archived = true
    if @todo_list.save
      flash.notice = "Successfully archived #{@todo_list.title}"
    else
      flash.alert = "Could not archive #{@todo_list.title}: #{@todo_list.errors.full_messages.join ','}"
    end
    redirect_back fallback_location: todo_lists_path
  end

  def restore
    @todo_list = current_user.todo_lists.find params[:id]
    @todo_list.archived = false
    if @todo_list.save
      flash.notice = "Successfully restored #{@todo_list.title}"
    else
      flash.alert = "Could not restore #{@todo_list.title}: #{@todo_list.errors.full_messages.join ','}"
    end
    redirect_back fallback_location: archived_todo_lists_path
  end

  private

  def todo_list_params
    params.require(:todo_list).permit(:title, :description)
  end
end
