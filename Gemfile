source 'https://rubygems.org'

ruby '3.3.0'

gem 'activerecord-session_store' # session_storeをActiveRecordに変更
gem 'bootsnap', require: false
gem 'bootstrap', '~> 5.3.2'
gem 'devise'
gem 'devise-i18n'
gem 'importmap-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'mysql2', '~> 0.5'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]
# markdown
gem 'redcarpet'

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'sassc-rails', '~> 2.1'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-fjord', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
