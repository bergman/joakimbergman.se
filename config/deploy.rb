default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "joakimbergman.se"
set :repository,  "git@github.com:bergman/joakimbergman.se.git"
set :scm, :git
set :deploy_to, "/srv/www/#{application}"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

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
end

after "deploy:update_code" do
end

after "deploy" do
  get_new_tweet
  lastfm
  update_crontab
end

desc "Symlink shared config files to new release"
task :symlink_config_files, :roles => :app do
  %w(database.yml).each do |file|
    run "ln -ns #{shared_path}/system/config/#{file} #{current_path}/config/#{file}"
  end
end

desc "Get new tweet"
task :get_new_tweet, :roles => :app do
  run "cd #{current_path} && RAILS_ENV=production rake twitter:timeline"
end

desc "lastfm"
task :lastfm, :roles => :app do
  run "cd #{current_path} && RAILS_ENV=production rake lastfm:artists"
end

desc "Update the crontab file"
task :update_crontab, :roles => :app do
  run "cd #{current_path} && whenever --update-crontab #{application}"
end
