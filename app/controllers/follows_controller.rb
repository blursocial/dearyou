class FollowsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      followed = User.find(params[:followed_id])
      follow = current_user.given_follows.new(followed: followed, status: "pending")
      if follow.save
        redirect_to user_profile_path(username: followed.username), notice: "Follow request sent."
      else
        redirect_to user_profile_path(username: followed.username), alert: "Unable to send follow request."
      end
    end
  
    def update
      follow = Follow.find(params[:id])
      if follow.followed == current_user
        follow.update(status: params[:status]) # 'accepted' or 'rejected'
        redirect_to follows_path, notice: "Follow request #{params[:status]}."
      else
        redirect_to root_path, alert: "You are not authorized to perform this action."
      end
    end
  
    def index
      @followers = current_user.followers
      @followeds = current_user.followeds
    end
  end
  