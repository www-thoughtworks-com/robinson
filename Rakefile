require 'bundler/setup'
require 'rspec/core/rake_task'

task :default => %w(test:functional)

namespace :test do

  desc 'Run functional tests'
  RSpec::Core::RakeTask.new(:functional) do |t|
    t.pattern = 'spec/functional/*_spec.rb'
  end

  desc 'Run unit tests'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/unit/*_spec.rb'
  end

end