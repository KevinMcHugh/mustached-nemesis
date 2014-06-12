module Character
  Dir[Rails.root.join("app","models","characters","*.rb")].each {|file| require file }
end