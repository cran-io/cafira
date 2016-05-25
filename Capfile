# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/bundler'

require 'capistrano/rails'

require 'capistrano/rbenv'

require 'capistrano/delayed-job'

set :rbenv_type, :user
set :rbenv_ruby, '2.2.2'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
