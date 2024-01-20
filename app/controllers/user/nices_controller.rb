class User::NicesController < ApplicationController

  def create
    @comment=Comment.find(params[:comment_id])
    nice=current_user.nices.new(comment_id: @comment.id)
    nice.save
    # create.js.erb
  end

  def destroy
    @comment=Comment.find(params[:comment_id])
    nice=current_user.nices.find_by(comment_id: @comment.id)
    nice.destroy
    # destroy.js.erb
  end

end
