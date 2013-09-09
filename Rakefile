require 'bundler/setup'
require 'rspec/core/rake_task'

task :default => %w(test:functional)

namespace :test do

  desc 'Run functional tests'
  RSpec::Core::RakeTask.new(:functional) do |t|
    t.pattern = 'spec/*_spec.rb'
  end

end