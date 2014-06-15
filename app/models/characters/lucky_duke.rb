# TODO: This assumes you always want to get out of jail, not be shot
# and not be dynamited. This is almost always true.
# Imagine you're the deputy, you have 4 health, and
# the sheriff has 1. You're dynamited and have the
# option to take the explosion.
module Character
  class LuckyDukePlayer < Player
    def draw!(reason)
      options = 2.times.map { deck.draw! }
      if [:jail, :dynamite].include?(reason)
        card = options.find { |option| !option.send(reasons_to_methods[reason]) }
      elsif reason == barrel
        card = options.find { |option| option.barreled? }
      end
      card ? card : options.first
    end

    private
    def reasons_to_methods
      { jail: :stll_in_jail?, dynamite: :explode? }
    end

  end
end
