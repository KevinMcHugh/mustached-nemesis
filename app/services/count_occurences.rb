class CountOccurences

  def initialize(array, offset = 0)
    @array = array
    @offset = offset
  end

  def execute
    counts = Hash.new(@offset)
    @array.each do |member|
      counts[member] += 1
    end
    counts
  end
end