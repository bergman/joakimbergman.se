default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "joakimbergman"
set :use_sudo, false

set :local_repository, "ssh://joakimbergman.se/srv/git/joakimbergman.se.git"
set :repository,  "file:///srv/git/joakimbergman.se.git"
set :scm, :git

set :deploy_to, "/srv/www/#{application}"

server "joakimbergman.se", :app, :web, :db, :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  after "update:code", :copy_config_files
  after "update:code", :update_crontab
end

desc "Copy shared config files to new release"
task :copy_config_files, :roles => :app do
  %w(database.yml).each do |conf|
    run "cp #{shared_path}/system/config/#{conf} #{release_path}/config/#{conf}"
  end
end


desc "Update the crontab file"
task :update_crontab, :roles => :app do
  run "cd #{release_path} && whenever --update-crontab #{application}"
end
