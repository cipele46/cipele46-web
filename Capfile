load 'deploy'
# Uncomment if you are using Rails' asset pipeline

load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks


namespace :deploy do
  task :copy_config, :except => { :no_release => true }, :role => :app do
    run "cp -f ~/cipele46-config/* #{release_path}/config"
  end
  
  desc "Pokreni db:setup na produkciji. Oprezno s tim..."
  task :db_setup do
    run "cd #{current_path} && rake db:setup RAILS_ENV=#{rails_env}"
  end
end

after "deploy:finalize_update", "deploy:copy_config"
after "deploy", "deploy:migrate"
