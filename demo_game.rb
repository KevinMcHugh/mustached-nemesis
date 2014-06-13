# RUN as 'rails r demo_game.rb'
require 'attack_left_brain'
require 'murder_brain'

CreateGame.new(brains: [PlayerBrain::MurderBrain,PlayerBrain::MurderBrain,PlayerBrain::MurderBrain,PlayerBrain::MurderBrain]).execute
