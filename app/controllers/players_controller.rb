class PlayersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @players = Player.paginate(:page => params[:page])
  end

  def show
    @player = Player.find(params[:id])
  end

end
