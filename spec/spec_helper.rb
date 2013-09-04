require 'simplecov'
SimpleCov.start

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Fog.mock!

CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.use_transactional_examples = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:suite) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }

  config.include FactoryGirl::Syntax::Methods
end

Dir[Rails.root.join("spec/concerns/**/*.rb")].each {|f| require f}

def sign_in(user)
  session[:user_id] = user.id
end

def user_signed_in?
  session[:user_id].blank?
end

def sign_out
  session.clear
end
