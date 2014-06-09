# TODO: This assumes you always want to get out of jail, not be shot
# and not be dynamited. This is almost always true.
# Imagine you're the deputy, you have 4 health, and
# the sheriff has 1. You're dynamited and have the
# option to take the explosion.

#bug in line 11 for barrel
class LuckyDuke
  def draw!(reason)
    options = 2.times.map { deck.draw! }
    card = options.find { |option| !option.send(reasons_to_methods[reason]) }
    card ? card : options.first
  end

  private
  def reasons_to_methods
    { jail: :stll_in_jail?, barrel: :barreled?, dynamite: :explode? }
  end

end
