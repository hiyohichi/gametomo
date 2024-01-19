class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to admin_users_path, notice: "ステータスを変更しました"
  end

  def destroy
    @comment = Comment.find(params[:id]).user
    Comment.find(params[:id]).destroy
    redirect_to admin_user_path(params[:user_id])
  end

  private

  def user_params
    params.require(:user).permit(:is_active )
  end

end
