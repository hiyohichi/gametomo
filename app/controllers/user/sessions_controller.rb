# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: "guestuserでログインしました。"
  end
  # before_action :configure_sign_in_params, only: [:create]
    before_action :user_state, only: [:create]
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def after_sign_in_path_for(resource)
      games_path
  end

  def after_sign_out_path_for(resource)
      root_path
  end
  
  private

    def user_state
    # userモデルに該当するメールが存在するか検索
     @user = User.find_by(email: params[:user][:email])
      if @user
      # 　メールで検索したユーザーのパスワードとログイン画面で入力されたパスワードが一致するか
        if @user.valid_password?(params[:user][:password]) && (@user.active_for_authentication? == false)
          flash[:notice] = "退会済みです"
          redirect_to new_user_registration_path
        else
          flash[:notice] = "項目を入力してください"
        end
      else 
        # モデルに該当するメールがない場合
        flash[:notice] = "該当するユーザーが見つかりません"
      end
    end
end
