class MonoLogger

  def initialize
    @logger = Logger.new(Rails.root.join("log", "game.log"))
  end

  def info(message)
    @logger.info(message)
  end
end
