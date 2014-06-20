# RUN as 'rails r demo_game.rb'
require 'attack_left_brain'
require 'murder_brain'
require 'plays_all_possible_cards_brain'
require 'mildly_intelligent_brain'
persist = ARGV.first

game = CreateGame.new(brains: [PlayerBrain::MildlyIntelligentBrain,PlayerBrain::MildlyIntelligentBrain,PlayerBrain::MildlyIntelligentBrain,PlayerBrain::MildlyIntelligentBrain], persist: persist).execute

 pp GameRecord.last.event_records.map(&:event_json)
# game.persist if persist
