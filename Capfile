load 'deploy'
# Uncomment if you are using Rails' asset pipeline

load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks

task :copy_config, :except => { :no_release => true }, :role => :app do
  run "cp -f ~/cipele46-config/* #{release_path}/config"
end

after "deploy:finalize_update", "copy_config"