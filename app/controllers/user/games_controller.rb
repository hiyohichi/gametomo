class User::GamesController < ApplicationController
  before_action :authenticate_user!,except:[:index]

  def index
    #1週間のコメントが多い順に並び替える
    to=Time.current.at_end_of_day
    from=(to - 6.day).at_beginning_of_day
    @games=Game.includes(:comments).
      sort_by {|game|
        game.comments.where(created_at: from...to).count
      }.reverse

    @genres = Genre.all
    if params[:genre_id].present?
      @genre = Genre.find(params[:genre_id])
      @games = @genre.games.all
    end
  end

  def show
    @game = Game.find(params[:id])
    @comment = Comment.new
    @comments = @game.comments.all
  end
end
