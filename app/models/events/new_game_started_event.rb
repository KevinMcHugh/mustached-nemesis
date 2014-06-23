class NewGameStartedEvent < Event
  def to_s
    <<-eos
      Startin' a new game, pardner!
      yeee-haw!

    eos
  end
end
