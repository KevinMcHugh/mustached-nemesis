require 'mildly_intelligent_brain'
class GameRecordsController < ApplicationController

  def create
    brains = [PlayerBrain::MildlyIntelligentBrain,PlayerBrain::MildlyIntelligentBrain,
      PlayerBrain::MildlyIntelligentBrain,PlayerBrain::MildlyIntelligentBrain]
    @game = CreateGame.new(brains: brains, persist: true).execute
    redirect_to game_record_path(@game.id)
  end

  def show
    @game_record = GameRecord.find(params[:id])
  end
end
