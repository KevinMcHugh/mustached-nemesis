module Character
  Dir[Rails.root.join("app","models","characters","*.rb")].each {|file| require file }
  def self.all(random)
    @@characters ||= Character.constants.select { |c| Character.const_get(c).is_a?(Class) }
    clone = @@characters.clone
    clone.sort!.shuffle!(random: random)
  end
end