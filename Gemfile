source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.2'
gem 'pg'

gem 'uglifier', '>= 1.3.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise'
gem 'grape'
gem 'grape-swagger-rails'
gem 'grape-entity'
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
  gem 'pundit-matchers', '~> 1.0.1'
  gem "codeclimate-test-reporter", require: nil
end
