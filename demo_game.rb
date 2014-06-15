# RUN as 'rails r demo_game.rb'
require 'attack_left_brain'
require 'murder_brain'
require 'plays_all_possible_cards_brain'

CreateGame.new(brains: [PlayerBrain::PlaysAllPossibleCardsBrain,PlayerBrain::PlaysAllPossibleCardsBrain,PlayerBrain::PlaysAllPossibleCardsBrain,PlayerBrain::MurderBrain]).execute
