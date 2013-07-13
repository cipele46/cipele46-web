require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :repository,    'git@github.com:cipele46/cipele46-web.git'
set :user,          'cipele46'
set :use_sudo,      false
set :deploy_via,    :remote_cache
set :default_stage, 'staging'
set :keep_releases, 3

after "deploy:finalize_update", "deploy:copy_config"

after "deploy", "deploy:migrate"

after 'deploy:restart', 'deploy:cleanup'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :copy_config do
    run "cd #{release_path} && rake config:defaults RAILS_ENV=#{rails_env}"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(release_path,'tmp','restart.txt')}"
  end
end
