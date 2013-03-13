Gem::Specification.new do |s|
  s.name = 'robinson'
  s.version = "0.0.2"
  s.date = '2013-03-13'
  s.authors = 'damned'
  s.summary = 'A working website link checker'
  s.files = [
    "Gemfile",
    "lib/robinson.rb"
  ]
  s.add_dependency "anemone"
  s.add_dependency "smart_colored"
  
  s.executables << 'robinson'
end

