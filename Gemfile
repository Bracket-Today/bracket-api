source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '>= 2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.6'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5'
# Use Puma as the app server
gem 'puma', '4.3.6'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'listen', '~> 3.3'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'arel-helpers'
gem 'awesome_print'
gem 'clockwork'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'graphql'
gem 'graphql_devise'
gem 'rack-cors'
gem 'twitter'

group :development, :test do
  # debugger
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # .env
  gem 'dotenv-rails'

  # testing
  gem 'guard-rspec', require: false
  gem 'rspec-rails', '~> 5.0.0'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'

  # deploy
  gem 'capistrano', '~> 3.15.0', require: false
  gem 'capistrano-clockwork'
  gem 'capistrano3-delayed-job', '~> 1.0'
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano3-puma', '~> 4.0.0'
end

source 'https://deploy:yQ9ryEUaPKqC@gems.pti-dev.com' do
  gem 'pti_base', '0.0.12'
  gem 'pti_tasks', '0.2.10'
end
