# RUN as 'rails r demo_game.rb'
require 'attack_left_brain'
require 'attack_right_brain'
require 'murder_brain'
require 'mildly_intelligent_brain'
require 'plays_all_possible_cards_brain'
require 'pp'

Rails.logger.level = Logger::WARN # turns off logging
arg = ARGV.first.to_i
iterations = arg.zero? ?  1000 : arg
games = iterations.times.map do |i|
  puts i if i % 1000 == 0
  CreateGame.new(brains: [PlayerBrain::AttackLeftBrain, PlayerBrain::AttackRightBrain,
    PlayerBrain::MurderBrain,PlayerBrain::MildlyIntelligentBrain, PlayerBrain::PlaysAllPossibleCardsBrain]).execute
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

puts "wins / brain"
pp brain_counter.sort_by {|key, value| value}
puts "wins / role:"
pp role_counter.sort_by {|key, value| value}
puts "rounds: "
pp round_counter.sort_by {|key, value| key}

all_players = games.flat_map(&:players)
appearance_counter = Hash.new(0)
total_appearances_per_player = all_players.map(&:class).reduce(appearance_counter){ |h, e| h[e] += 1 ; h }
stats = total_appearances_per_player.merge(player_counter) do |key, oldval, newval|
  { win_percentage: newval.to_f / oldval, games_won: newval,  games_played: oldval, played_percentage: oldval.to_f / games.size }
end
stats.each_pair do |key, value|
  stats[key] = { win_percentage: 0, games_played: value, games_won: 0, played_percentage: 0} if value.is_a? Fixnum
end

puts "winningness / character"
pp stats.sort_by {|key, value| value[:win_percentage]}

['renegade', 'sheriff', 'outlaw', 'deputy'].each do |role|
  brain_counter = Hash.new(0)

  role_wins = winners.find_all { |array| array.map(&:role).include?(role)}
  winning_players_for_role = role_wins.flatten.find_all { |player| player.role == role }
  winning_players_for_role.map(&:brain).map(&:class).reduce(brain_counter){ |h, e| h[e] += 1 ; h }

  brains = brain_counter.sort_by {|key, value| value}
  unless role_wins.empty?
    puts "#{role} won #{role_wins.size} times as"
    pp brains
  end
end
