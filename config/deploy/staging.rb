set :application, 'cipele46staging'
set :rails_env,   'staging'
set :deploy_to,   "/home/#{user}/#{application}"
set :branch,      'dev'

role :web, 'staging.cipele46.org'                         
role :app, 'staging.cipele46.org'                       
role :db,  'staging.cipele46.org', :primary => true 

