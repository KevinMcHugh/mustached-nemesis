class BrainsController < ApplicationController

  def index
    @stats = BrainStats.new.execute
  end
end