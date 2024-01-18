class User::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    book=Book.find(params[:book_id])
    @comment=current_user.book_comments.new(book_comment_params)
    @comment.book_id=book.id
    @comment.save
    #create.js.erb
  end

  def destroy
    @book=BookComment.find(params[:id]).book
    BookComment.find(params[:id]).destroy
    #destroy.js.erb
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
end
