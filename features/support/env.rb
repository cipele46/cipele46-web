ENV['RAILS_ENV'] ||= 'test'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
elsif ENV["RAILS_ENV"] == "test"
  require 'simplecov'
  SimpleCov.start 'rails'
  SimpleCov.coverage_dir 'coverage/features'
end

require "./config/environment"

require "rspec/rails"
require 'spinach/capybara'
require 'capybara/poltergeist'

DatabaseCleaner.strategy = :truncation

Spinach.hooks.before_scenario do
  DatabaseCleaner.start
end

Spinach.hooks.after_scenario do
  DatabaseCleaner.clean
end

Spinach.hooks.before_run do
  include FactoryGirl::Syntax::Methods
  Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
end

Spinach.hooks.on_tag("search") do
  include SunspotHelper
  setup_solr
end

Spinach.hooks.on_tag("javascript") do
  ::Capybara.current_driver = :poltergeist
end
