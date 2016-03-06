source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
gem 'pg'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise'
gem 'grape'
gem 'pundit'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'rack-mini-profiler'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'mailcatcher'
  gem 'pry'
  gem 'pry-byebug'
  gem 'zeus'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

group :test do
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'turnip'
end
