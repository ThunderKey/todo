class TodoListsController < ApplicationController
  def index
    @todo_lists = current_user.todo_lists
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
      flash.alert = 'Could not save the todo list'
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
      flash.alert = 'Could not save the todo list'
      render :edit
    end
  end

  private

  def todo_list_params
    params.require(:todo_list).permit(:title, :description)
  end
end
