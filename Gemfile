source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

gem "rails", "~> 7.0.4", ">= 7.0.4.2"

gem "pg", "~> 1.1"

gem "puma", "~> 5.0"

# IMPORTED
gem 'rubyzip', '~> 2.3.2'
# gem 'pastore', '~> 0.1.0'
# gem 'active_model_serializers', '~> 0.10.13'
gem 'redis', '~> 4.3.1'
gem 'redis-namespace', '~> 1.8.2'
gem 'sidekiq-cron', '~> 1.7.0'
gem 'will_paginate', '~> 3.3.0'
gem 'activerecord-import', '~> 1.3.0'
gem 'simple_command', '~> 0.1.0'
# gem 'rotp', '~> 6.2.0'
# gem 'jwt', '~> 2.2.3'
gem 'mail', '~> 2.8.1'
gem 'sidekiq', '~> 6.2.1'
# gem 'grover', '~> 1.1.0'
gem 'mustache', '~> 1.1.1'
# gem 'image_processing', '~> 1.12.1'
# gem 'mini_magick', '~> 4.11.0'
gem 'timeout', '~> 0.3.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'database_cleaner', '~> 2.0.1', require: false
  gem 'factory_bot_rails', '~> 6.2.0', require: false
  gem 'faker', '~> 3.0.0', require: false
  gem 'pry', require: false
  gem 'rspec-rails', '~> 6.0.1'
  gem 'shoulda-matchers', '~> 5.2.0', require: false
  gem 'rails-controller-testing', '~> 1.0.5'

  gem 'guard', '~> 2.18.0'
  gem 'guard-rspec', '~> 4.7.3'
  gem 'guard-rails', '~> 0.8.1'
  gem 'guard-test', '~> 2.0.8'
  gem 'launchy', '~> 2.5.2'

  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

