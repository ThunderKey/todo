class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def keltec
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Keltec') if is_navigational_format?
    else
      flash.alert = 'This user is not allowed to use this application'
      redirect_to new_user_session_path
    end
  end
end
