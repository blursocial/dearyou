class UsersController < ApplicationController
  layout "profile"
  before_action :authenticate_user!, except: :show
  before_action :set_user, only: %i[edit update show settings update_settings]

  def edit
  end

  def settings
    if @user != current_user
      redirect_to root_path, alert: "You are not authorized to view this page."
    else
      @settings = @user.settings
    end
  end

  def update_settings
    if @user != current_user
      redirect_to root_path, alert: "You are not authorized to update these settings."
    else
      settings_params.each do |key, value|
        @user.update_setting(key, value)
      end

      redirect_to settings_user_path(@user), notice: "Settings updated successfully."
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_profile_path(username: @user.username), notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @posts = @user.posts
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  end

  def user_params
    params.require(:user).permit(:name, :bio)
  end

  def settings_params
    params.require(:settings).permit(:auto_accept_follows)
  end
end
