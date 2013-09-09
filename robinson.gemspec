Gem::Specification.new do |s|
  s.name = 'robinson'
  s.version = '0.0.4'
  s.date = '2013-03-13'
  s.authors = 'damned'
  s.summary = 'A working website link checker'
  s.files = %w(Gemfile
              lib/robinson.rb
              lib/investigative_reporter.rb
              lib/invocation.rb
              lib/link.rb
              lib/noisy_reporter.rb
              lib/page.rb
              lib/investigative_reporter.rb
              lib/reporter.rb
  )
  s.add_dependency 'anemone'
  s.add_dependency 'smart_colored'
  
  s.executables << 'robinson'
end

