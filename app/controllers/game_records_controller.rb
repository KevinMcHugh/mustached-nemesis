require 'example_brains'
class GameRecordsController < ApplicationController

  def create
    number_of_games = params[:game_record][:number_of_games] || 1
    brains = parse_brains

    number_of_games.to_i.times do |i|
      CreateGame.new(brains: brains, persist: true).execute
    end
    @game_records = GameRecord.last(number_of_games)
    render action: 'index'
  end

  def new
    previous_game = GameRecord.last
    previous_game_brains = previous_game ? previous_game.player_records.map(&:brain) : []
    all_brains = PlayerBrain.all.map(&:to_s) + previous_game_brains
    offset = previous_game ? -1 : 0
    @brains = CountOccurences.new(all_brains, offset).execute
  end

  def show
    @game_record = GameRecord.find(params[:id])
  end

  def index
    @game_records = GameRecord.all
  end

  private
  def parse_brains
    brain_classes = params[:game_record].flat_map do |key, value|
      begin
        value.to_i.times.map { key.constantize }
      rescue NameError => e
      end
    end.compact
    brain_classes.empty? ? PlayerBrain.all : brain_classes
  end
end
