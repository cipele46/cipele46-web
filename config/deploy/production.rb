set :application, 'cipele46'
set :rails_env,   'production'
set :deploy_to,   "/home/#{user}/#{application}"
set :branch,      'master'

role :web, 'cipele46.org'                         
role :app, 'cipele46.org'                       
role :db,  'cipele46.org', :primary => true 

# This dumps the production database and restores it to local development one
# For it to work you need to have your ssh key on cipele46.org
# Local database is assumed to be MySQL with empty root password
#
# WARNING: This will drop your existing development database
#
namespace :db do
  task :dump_to_local do
    file_path = "~/dbdump"
    file_name = "cipele46_production_dump"
    run "cd #{file_path} && echo \"SET SESSION SQL_LOG_BIN=0;\" > #{file_name}.sql && mysqldump --user=root cipele46_production >> #{file_name}.sql"
    run "cd #{file_path} && tar cvzf #{file_name}.tgz #{file_name}.sql --remove-files"

    system "scp cipele46@cipele46.org:#{file_path}/#{file_name}.tgz /tmp/#{file_name}.tgz"

    run "cd #{file_path} && rm #{file_name}.tgz"

    system "cd /tmp && tar xvzf /tmp/#{file_name}.tgz && rm /tmp/#{file_name}.tgz"
    system "mysql -uroot -e 'drop database cipele46_development; create database cipele46_development;'"
    system "mysql -uroot cipele46_development < /tmp/#{file_name}.sql"

    system "mysql -uroot cipele46_development -e \"update users set email = CONCAT('user_id_', id, '+', 'cipele46dev@gmail.com')\""

    system "rm /tmp/#{file_name}.sql"
  end
end
