class User::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    game=Game.find(params[:game_id])
    @comment=current_user.comments.new(comment_params)
    @comment.game_id=game.id
    @comment.save
    #create.js.erb
  end

  def destroy
    @game=Comment.find(params[:id]).game
    Comment.find(params[:id]).destroy
    #destroy.js.erb
  end

  private
  def comment_params
    params.require(:comment).permit(:comment)
  end
end
