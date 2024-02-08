class User::UsersController < ApplicationController
  before_action :authenticate_user!,except:[:index]
  before_action :ensure_guest_user, only: [:edit]
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    #1週間のフォロワーが多い順に並び替える
    to=Time.current.at_end_of_day
    from=(to - 6.day).at_beginning_of_day
    @users=User.includes(:followers).
      sort_by {|user|
        user.followers.where(created_at: from...to).count
      }.reverse
    @user=current_user
  end

  def show
    @user=User.find(params[:id])
    @comments=@user.comments.includes(:game).order(created_at: :desc)
  end

  def edit
    @genres= Genre.all
  end

  def update
    user=User.find(params[:id])
    if user.update(user_params)
      redirect_to user_path(user), notice: "プロフィールを編集しました"
    else
      @genres = Genre.all
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,:profile_image,:introduction, genre_ids:[])
  end

  def is_matching_login_user
    user=User.find(params[:id])
    unless user.id == current_user.id
      redirect_to current_user
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

end
