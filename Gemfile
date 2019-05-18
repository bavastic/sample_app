# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.4'

gem 'active_model_serializers', '~> 0.10.9'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'faker'
gem 'has_unique_identifier', path: 'lib/has_unique_identifier'
gem 'jbuilder', '~> 2.5'
gem 'kaminari'
gem 'loofah', '>= 2.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rack', '>= 2.0.6'
gem 'rails', '~> 5.2.1'
gem 'sass-rails', '~> 5.0'
gem 'semantic-ui-sass'
gem 'strong_migrations', '~> 0.3.1'
gem 'swagger-blocks'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)
gem 'uglifier', '>= 1.3.0'
gem 'webdack-uuid_migration', '~> 1.2.0'
gem 'webpacker', '>= 4.0.x'

group :development, :test do
  gem 'annotate'
  gem 'byebug', platforms: %i(mri mingw x64_mingw)
  gem 'coveralls', require: false
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '0.68.1', require: false
  gem 'simplecov', '~> 0.16.0', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end
