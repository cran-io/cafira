# config valid only for Capistrano 3.1
lock '3.4.1'

set :application, 'cafira'
set :repo_url, 'git@github.com:cran-io/cafira.git'
set :deploy_to, '/home/deploy/cafira'

set :linked_files, %w{config/database.yml}
set :bundle_binstubs, nil
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :rbenv_path, '/home/deploy/.rbenv/'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'

  after 'deploy:published', 'restart' do
    invoke 'delayed_job:restart'
  end
end
