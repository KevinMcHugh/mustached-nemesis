class GameRecordsController < ApplicationController

  def create
    brains = params[:game_record][:brains].reject(&:empty?)
    brain_classes = brains.map(&:constantize)
    @game = CreateGame.new(brains: brain_classes, persist: true).execute
    redirect_to game_record_path(GameRecord.last)
  end

  def new
    @brains = [[PlayerBrain::MildlyIntelligentBrain, PlayerBrain::MildlyIntelligentBrain],
                [PlayerBrain::AttackLeftBrain,PlayerBrain::AttackLeftBrain],
                [PlayerBrain::AttackRightBrain,PlayerBrain::AttackRightBrain],
                [PlayerBrain::PlaysAllPossibleCardsBrain,PlayerBrain::PlaysAllPossibleCardsBrain]]
  end

  def show
    @game_record = GameRecord.find(params[:id])
  end

  def index
    @game_records = GameRecord.all
  end
end
