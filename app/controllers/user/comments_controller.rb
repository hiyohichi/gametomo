class User::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:destroy]

  def create
    game=Game.find(params[:game_id])
    @comment=current_user.comments.new(comment_params)
    @comment.game_id=game.id
    @comment.save
    @comments=game.comments.all.order(created_at: :desc)
    #create.js.erb
  end

  def destroy
    @game=Comment.find(params[:id]).game
    Comment.find(params[:id]).destroy
    @comments = @game.comments.all.order(created_at: :desc)
    #destroy.js.erb
  end

  private
  def comment_params
    params.require(:comment).permit(:comment, :user_id, :game_id, :parent_id)
  end

  def is_matching_login_user
    comment = Comment.find(params[:id])
    unless comment.user_id == current_user.id
      redirect_to current_user
      flash[:notice]="不正が検知されました"
    end
  end
end
