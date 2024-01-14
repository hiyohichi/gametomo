class User::UsersController < ApplicationController
  before_action :authenticate_user!,except:[:index]
  before_action :ensure_guest_user, only: [:edit]
  
  
  private
  
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end  
end
