class Admin::GamesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @game = Game.new
    @genres = Genre.all
  end

  def create
    @game = Game.new(game_params)
    params[:game][:genre] ? @game.genre = params[:game][:genre].join(",") : false
    if @game.save
      redirect_to admin_games_path
    else
      @genres = Genre.all
      render :new
    end
  end

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
    @comments = Comment.all
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    params[:game][:genre] ? @game.genre = params[:game][:genre].join(",") : false
    if @game.update(game_params)
      redirect_to admin_game_path(@game)
    else
      @genres = Genre.all
      render :edit
    end
  end

  private

  def game_params
    params.require(:game).permit(:title, :introduction, :genre_id, :game_image)
  end
end
