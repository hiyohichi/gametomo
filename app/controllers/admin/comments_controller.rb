class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def destroy
    user = User.find(params[:user_id])
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to admin_user_path(user)
  end
end