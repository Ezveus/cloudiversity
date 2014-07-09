source 'https://rubygems.org'

gem 'rails',        '4.0.4'
gem 'less-rails'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jbuilder',     '~> 1.2'
gem 'haml',         '~> 4.0.3'
gem 'haml-rails'
gem 'devise'
gem 'devise-encryptable'
gem 'simple_token_authentication'
gem 'pundit'
gem 'rails_uikit', github: 'adaedra/rails_uikit'
gem 'therubyracer', platforms: :ruby
gem 'therubyrhino', platforms: :jruby
gem 'carrierwave'
gem 'codemirror-rails', '~> 4.2'
gem 'nested_form'
gem 'will_paginate', '~> 3.0'

group :doc do
    gem 'yard', require: false
end

group :development do
    gem 'binding_of_caller', platforms: :ruby
    gem 'better_errors'
    gem 'pry'
    gem 'pry-rails'

    gem 'sqlite3', platforms: :ruby
    gem 'activerecord-jdbcsqlite3-adapter', platforms: :jruby

    gem 'letter_opener'
end

group :development, :test do
    gem 'rspec-rails', '~> 2.14'
    gem 'factory_girl_rails', '~> 4.4.0'
    gem 'database_cleaner', '~> 1.2.0'
end

group :production do
    # Choose a database
    # gem 'sqlite3'
    # gem 'mysql2'
    # gem 'pg'
    # 
    # Or, if you're using jruby
    # gem 'activerecord-jdbcsqlite3-adapter'
    # gem 'activerecord-jdbcmysql-adapter'
    # gem 'activerecord-jdbcpostgresql-adapter'
    # gem 'activerecord-jdbcmssql-adapter'
end

# A web server, compatible with YRI and JRuby
gem 'puma'
