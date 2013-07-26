require 'simplecov' unless ENV['CI']

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

ENV['RAILS_ENV'] ||= 'test'
require "./config/environment"

require "rspec/rails"

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
