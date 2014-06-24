# RUN as 'rails r demo_game.rb'
persist = ARGV.first

game = CreateGame.new(brains: [ExampleBrains::MildlyIntelligentBrain,
  ExampleBrains::MildlyIntelligentBrain,
  ExampleBrains::MildlyIntelligentBrain,
  ExampleBrains::MildlyIntelligentBrain], persist: persist).execute

event_strings =  GameRecord.last.event_records.map(&:event_json)
event_strings.each do |string|
  puts string
end
