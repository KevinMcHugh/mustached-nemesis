require 'example_brains'
class GameRecordsController < ApplicationController

  def create
    brains = params[:game_record][:brains].reject(&:empty?)
    brain_classes = brains.map(&:constantize)
    number_of_games = params[:game_record][:number_of_games] || 1
    number_of_games.to_i.times do |i|
      CreateGame.new(brains: brain_classes, persist: true).execute
    end
    @game_records = GameRecord.last(number_of_games)
    render action: 'index'
  end

  def new
    @brains = PlayerBrain.all.map { |brain| [brain, brain]}
  end

  def show
    @game_record = GameRecord.find(params[:id])
  end

  def index
    @game_records = GameRecord.all
  end
end
