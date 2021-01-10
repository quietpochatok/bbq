source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'

gem 'puma', '~> 4.1'
gem 'webpacker', '~> 4.0'
gem 'devise'
gem 'devise-i18n'
gem 'russian'
gem 'rails-i18n', '~> 6.0.0'
gem 'carrierwave'
gem 'rmagick'
gem 'fog-aws'
gem 'pundit', '~> 2.1'
gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
gem "mailjet"
gem 'resque', '~> 2.0.0'

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3', '~> 1.4'
  gem "letter_opener"

  gem 'rspec-rails', '~> 3.4'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'capistrano', '~> 3.11.0'
  gem 'capistrano-rails', '~> 1.3.0'
  gem 'capistrano-passenger', '~> 0.2'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'capistrano-bundler', '~> 1.4.0'
  gem 'capistrano-resque', '~> 0.2.3', require: false
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
