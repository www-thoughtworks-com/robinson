Gem::Specification.new do |s|
  s.name = 'robinson'
  s.version = '0.0.17'
  s.date = '2014-09-11'
  s.authors = 'damned'
  s.summary = 'A mainly working website link checker'
  s.files = %w(Gemfile
              lib/robinson.rb
              lib/investigative_reporter.rb
              lib/invocation.rb
              lib/link.rb
              lib/noisy_reporter.rb
              lib/options.rb
              lib/page.rb
              lib/investigative_reporter.rb
              lib/reporter.rb
  )
  s.add_dependency 'anemone'
  s.add_dependency 'smart_colored'


  s.executables << 'robinson'
  s.description = 'Robinson is a link checker based on anemone'
end

