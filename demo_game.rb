# RUN as 'rails r demo_game.rb'
persist = ARGV.first

game = CreateGame.new(brains: [ExampleBrains::MurderBrain,
  ExampleBrains::MildlyIntelligentBrain,
  ExampleBrains::MildlyIntelligentBrain,
  ExampleBrains::MildlyIntelligentBrain], persist: persist).execute

event_strings = game.events
event_strings.each do |string|
  puts string
end
