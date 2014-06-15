# RUN as 'rails r demo_game.rb'
require 'attack_left_brain'
require 'attack_right_brain'
require 'murder_brain'
require 'pp'
Rails.logger.level = Logger::WARN # turns off logging
iterations = ARGV.first.to_i || 1000
games = iterations.times.map do |i|
  puts i if i % 200 == 0
  CreateGame.new(brains: [PlayerBrain::AttackLeftBrain,PlayerBrain::AttackLeftBrain,
    PlayerBrain::AttackRightBrain,PlayerBrain::AttackRightBrain,PlayerBrain::MurderBrain,PlayerBrain::MurderBrain]).execute
end

winners = games.map(&:winners)
brain_counter = Hash.new(0)
role_counter = Hash.new(0)
player_counter = Hash.new(0)
round_counter = Hash.new(0)
winners.each do |winner_array|
  winner_array.map(&:brain).map(&:class).uniq.reduce(brain_counter){ |h, e| h[e] += 1 ; h }
  winner_array.map(&:role).uniq.reduce(role_counter){ |h, e| h[e] += 1 ; h }
  winner_array.map(&:class).uniq.reduce(player_counter){ |h, e| h[e] += 1 ; h }
end

games.map(&:round).reduce(round_counter){ |h, e| h[e] += 1 ; h }

pp brain_counter.sort_by {|key, value| value}
pp role_counter.sort_by {|key, value| value}
pp player_counter.sort_by {|key, value| value}
pp round_counter.sort_by {|key, value| key}

brain_counter = Hash.new(0)
renegade_wins = winners.find_all { |array| array.map(&:role).include?('renegade')}

renegade_wins.map(&:first).map(&:brain).map(&:class).reduce(brain_counter){ |h, e| h[e] += 1 ; h }

brains = brain_counter.sort_by {|key, value| value}
puts "renegade won #{renegade_wins.size} times as"
pp brains
