source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'

gem 'bootsnap', '>= 1.4.4', require: false

gem 'devise'
gem 'active_model_serializers', '~> 0.10.12'
gem 'ransack', '~> 2.4', '>= 2.4.2'
# gem 'rack-cors'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 5.0', '>= 5.0.1'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'faker'
end

group :test do
  gem 'shoulda-matchers', '~> 4.5', '>= 4.5.1'
  gem 'database_cleaner'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'spring-commands-rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
