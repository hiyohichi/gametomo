class Admin::GamesController < ApplicationController
  before_action :authenticate_admin!

end
