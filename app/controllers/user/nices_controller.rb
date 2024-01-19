class User::NicesController < ApplicationController
  
  def create
    @game=Game.find(params[:game_id])
    nice=current_user.nices.new(game_id: @game.id)
    nice.save
    # create.js.erb
  end

  def destroy
    @game = Game.find(params[:game_id])
    nice=current_user.nices.find_by(game_id: @game.id)
    nice.destroy
    # destroy.js.erb
  end
  
end
