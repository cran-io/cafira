source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.4'
gem 'pg'
gem 'therubyracer', platforms: :ruby
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'activeadmin', '1.0.0.pre1'
gem 'activeadmin-translate'
gem 'devise'
gem 'active_admin_theme'
gem 'cancan'
gem 'axlsx'
gem 'sdoc', '~> 0.4.0', group: :doc
gem "paperclip", "~> 4.3"
gem 'rubyzip'
gem 'delayed_job_active_record'
gem 'gibbon'
gem 'ckeditor', github: 'galetahub/ckeditor'

group :development, :test do
	gem 'rspec-rails'
	gem 'rspec-its'
	gem 'pry-rails'
	gem 'factory_girl_rails'
	gem 'faker'
	gem 'spring'
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano3-delayed-job', '~> 1.0'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-rbenv', github: "capistrano/rbenv"
end

group :test do
	gem 'database_cleaner'
	gem 'simplecov', :require => false
end

group :production do
  gem 'exception_notification'
end
