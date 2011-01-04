$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_type, :user
set :rvm_ruby_string, '1.9.2'        # Or whatever env you want it to run in.
require "bundler/capistrano"
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "joakimbergman.se"
set :repository,  "git@github.com:bergman/joakimbergman.se.git"
set :scm, :git
set :deploy_to, "/var/www/#{application}"
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false

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
  symlink_config_files
  symlink_database
  get_new_tweet
  lastfm
  update_crontab
end

desc "Symlink database to new release"
task :symlink_database, :roles => :app do
  %w(production.sqlite3).each do |file|
    run "ln -ns #{shared_path}/system/db/#{file} #{release_path}/db/#{file}"
  end
end

desc "Symlink shared config files to new release"
task :symlink_config_files, :roles => :app do
  %w(database.yml).each do |file|
    run "ln -ns #{shared_path}/system/config/#{file} #{release_path}/config/#{file}"
  end
end

desc "Get new tweet"
task :get_new_tweet, :roles => :app do
  run "cd #{release_path} && RAILS_ENV=production bundle exec rake twitter:timeline"
end

desc "lastfm"
task :lastfm, :roles => :app do
  run "cd #{release_path} && RAILS_ENV=production bundle exec rake lastfm:artists"
end

desc "Update the crontab file"
task :update_crontab, :roles => :app do
  run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
end
