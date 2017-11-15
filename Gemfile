source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.10'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1', '>= 3.1.11'

# Authentication
gem 'devise_token_auth', '~> 0.1.42'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.0', '>= 1.0.2', require: 'rack/cors'

# Pagination
gem 'will_paginate', '~> 3.1', '>= 3.1.6'

# MetaSearch
gem 'ransack', '~> 1.8', '>= 1.8.4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Code Style checking tool
  gem 'rubocop', '~> 0.51.0'
end

group :test do
  # Specs
  gem 'rspec-rails', '~> 3.7', '>= 3.7.1'

  # Factories
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'

  # Generates Fake Data
  gem 'faker', '~> 1.8', '>= 1.8.4'

  # Shoulda Matchers
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec', '~> 1.0', '>= 1.0.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
