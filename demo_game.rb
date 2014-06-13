# RUN as 'rails r demo_game.rb'
require 'attack_left_brain'
CreateGame.new(brains: [PlayerBrain::AttackLeftBrain,PlayerBrain::AttackLeftBrain,PlayerBrain::AttackLeftBrain,PlayerBrain::AttackLeftBrain]).execute
