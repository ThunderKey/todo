class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.attributes = params.require(:user).permit(:time_zone)
    time_zone_changed = @user.time_zone_changed?
    if @user.save
      flash.notice = t 'page.user.update.successful'
      flash[:warning] = t 'page.user.update.time_zone_changed' if time_zone_changed
      redirect_back fallback_location: edit_user_path
    else
      render :edit
    end
  end
end
