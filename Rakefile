#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test) do |task|
  task.pattern    = Dir['**/spec/models/*_spec.rb','**/spec/services/*_spec.rb']
end
