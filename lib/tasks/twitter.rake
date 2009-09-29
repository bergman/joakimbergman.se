namespace :twitter do
  task :timeline => :environment do
    require 'open-uri'
    twitter = YAML.load_file File.join(RAILS_ROOT, 'config', 'twitter.yml')
    timeline = ActiveSupport::JSON.decode(open("http://twitter.com/statuses/user_timeline/#{twitter["user"]}.json").read).to_yaml
    file = File.open(File.join(RAILS_ROOT, 'tmp', 'twitter_timeline.yml'), "w")
    file.puts(timeline)
    file.close
  end
end