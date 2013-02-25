source 'https://rubygems.org'

ruby "1.9.3"

gem 'rails', '3.2.11'
gem 'therubyracer', '~> 0.10.2'
gem "seed_dumper", "~> 0.1.3"
gem 'jquery-rails', '2.1.3'

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

group :development do
  # Mongrel has better network performance than Webrick
  gem 'mongrel'
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
