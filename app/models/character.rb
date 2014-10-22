module Character
  Dir[Rails.root.join("app","models","characters","*.rb")].each {|file| require file }
  def self.all
    @@characters ||= Character.constants.select { |c| Character.const_get(c).is_a?(Class) }
    @@characters.clone
  end
end