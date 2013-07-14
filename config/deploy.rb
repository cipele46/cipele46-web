require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :repository,    'git@github.com:cipele46/cipele46-web.git'
set :user,          'cipele46'
set :use_sudo,      false
set :deploy_via,    :remote_cache
set :default_stage, 'staging'
set :keep_releases, 3
set :solr_path, '/opt/apache-solr-3.6.2/example'

after "deploy:finalize_update", "deploy:copy_config"

after "deploy", "deploy:migrate"

after 'deploy:restart', 'deploy:cleanup'
after 'deploy:stop',    'solr:stop'
after 'deploy:start',   'solr:start'

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

require './config/boot'
require 'airbrake/capistrano'


namespace :solr do
  task :start do
  	run "cd #{ current_path } && bundle exec sunspot-solr start -d #{ solr_path }/#{solr_data} -s " +
      "#{ current_path }/solr -j #{ solr_path }/start.jar --pid-dir #{ shared_path }/pids -p #{solr_port}" +
      "--log-file=#{ shared_path }/log/solr.log --max-memory=384M --min-memory=128M --log-level=WARNING"
  end
  task :stop do
  	run "cd #{ current_path } && bundle exec sunspot-solr stop --pid-dir #{ shared_path }/pids "
  end
end


