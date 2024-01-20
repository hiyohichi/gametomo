class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @games = Game.looks(params[:search], params[:word])
    end
    render 'searches/search'
  end
end
