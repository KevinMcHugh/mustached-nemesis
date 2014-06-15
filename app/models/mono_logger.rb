class MonoLogger
  @@logger = Logger.new(Rails.root.join("log", "game.log"))

  def info(message)
    @@logger.info(message)
  end
end
