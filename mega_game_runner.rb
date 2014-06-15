# RUN as 'rails r demo_game.rb'
require 'attack_left_brain'
require 'attack_right_brain'
require 'murder_brain'
require 'pp'
Rails.logger.level = Logger::WARN # turns off logging
iterations = ARGV.first.to_i || 1000
games = iterations.times.map do
  CreateGame.new(brains: [PlayerBrain::AttackLeftBrain,PlayerBrain::AttackLeftBrain,PlayerBrain::AttackRightBrain,PlayerBrain::AttackRightBrain]).execute
end
games += iterations.times.map do
  CreateGame.new(brains: [PlayerBrain::MurderBrain,PlayerBrain::MurderBrain,PlayerBrain::AttackRightBrain,PlayerBrain::AttackRightBrain]).execute
end
games += iterations.times.map do
  CreateGame.new(brains: [PlayerBrain::MurderBrain,PlayerBrain::MurderBrain,PlayerBrain::AttackLeftBrain,PlayerBrain::AttackLeftBrain]).execute
end

winners = games.map(&:winners)
brain_counter = Hash.new(0)
role_counter = Hash.new(0)
player_counter = Hash.new(0)
round_counter = Hash.new(0)

winners.each do |winner_array|
  winner_array.reduce(brain_counter){ |h, e| h[e.brain.class] += 1 ; h }
  winner_array.reduce(role_counter){ |h, e| h[e.role] += 1 ; h }
  winner_array.reduce(player_counter){ |h, e| h[e.class] += 1 ; h }
end

games.map(&:round).reduce(round_counter){ |h, e| h[e] += 1 ; h }

pp brain_counter.sort_by {|key, value| value}
pp role_counter.sort_by {|key, value| value}
pp player_counter.sort_by {|key, value| value}
pp round_counter.sort_by {|key, value| key}

