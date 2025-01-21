class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin
  
    def index
      @users = User.all
    end
  
    def edit
      @user = User.find(params[:id])
    end
  
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "User role updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    private
  
    def ensure_admin
      redirect_to root_path, alert: "Access denied." unless current_user.admin?
    end
  
    def user_params
      params.require(:user).permit(:role)
    end
  end
  