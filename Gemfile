source 'https://rubygems.org'

ruby "2.0.0"

gem 'rails', '3.2.11'
gem 'therubyracer', '~> 0.10.2'
gem "seed_dumper", "~> 0.1.3"
gem 'jquery-rails', '2.1.3'

gem 'awesome_print'
gem 'ruby-prof'

# For app config and settings
gem "rails_config"

# For cleaner controller implementation
gem 'inherited_resources'
gem 'has_scope'

# For uploading files/images and processing of images
gem 'carrierwave'
gem 'mini_magick'

# To use ActiveAdmin administration
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'activeadmin'

# For pagination
gem "kaminari"

# For Google+ Signin
gem 'google-api-client', '>= 0.6.2', :require => 'google/api_client'
gem 'signet', '>=0.4.5'
gem 'json'

group :development do
  # Mongrel has better network performance than Webrick
  # gem 'mongrel'
  # gem 'thin'
  gem 'sqlite3', '1.3.6'
end

group :production do
  gem 'pg', '0.12.2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.3.0'
end

#
# Testing frameworks
#
group :test do
  gem 'watir-rails'
  gem 'headless'
end
