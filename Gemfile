source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '4.0.0'
gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'zurb-foundation'
gem 'turbolinks'
gem 'simple_form'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'figaro'
gem 'bourbon'
gem 'thin'
gem 'therubyracer'

group :production do
  gem 'rails_12factor'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'forgery'
  gem 'database_cleaner'
  gem 'ejs'
end

group :development do
  gem 'pry-rails'
  gem 'zeus'
end

group :test, :development do
  gem 'konacha'
  gem 'poltergeist'
end