require 'example_brains'
class GameRecordsController < ApplicationController

  def create
    brains = params[:game_record][:brains].reject(&:empty?)
    brain_classes = brains.map(&:constantize)
    number_of_games = params[:number_of_games] || 1
    number_of_games.to_i.times do |i|
      CreateGame.new(brains: brain_classes, persist: true).execute
    end
    @game_records = GameRecord.last(number_of_games)
    render action: 'index'
  end

  def new
    @brains = [twice(ExampleBrains::MildlyIntelligentBrain),
                twice(ExampleBrains::AttackLeftBrain),
                twice(ExampleBrains::AttackRightBrain),
                twice(ExampleBrains::PlaysAllPossibleCardsBrain),
                twice(KevinsPropietaryBrain::Brain)]
  end

  def show
    @game_record = GameRecord.find(params[:id])
  end

  def index
    @game_records = GameRecord.all
  end

  private
  def twice(brain)
    2.times.map { brain }
  end
end
