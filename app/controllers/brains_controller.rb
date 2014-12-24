class BrainsController < ApplicationController

  def index
    @brains = PlayerBrain.all
  end

  def show
    @brain = params[:id].constantize
    @brain_stats = BrainStats.new(@brain).execute
  end
end