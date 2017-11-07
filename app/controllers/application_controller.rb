class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  around_action :set_time_zone, if: :current_user

  def new_session_path(_scope)
    new_user_session_path
  end

  private

  def set_time_zone &block
    if current_user.time_zone
      Time.use_zone current_user.time_zone, &block
    else
      @time_zone_missing = true
      block.call
    end
  end
end
