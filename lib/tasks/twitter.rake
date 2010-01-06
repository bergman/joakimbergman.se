namespace :twitter do
  task :timeline => :environment do
    require 'open-uri'
    twitter_user = (YAML.load_file File.join(RAILS_ROOT, 'config', 'twitter.yml'))["user"]
    timeline = ActiveSupport::JSON.decode(open("http://twitter.com/statuses/user_timeline/#{twitter_user}.json").read)
    unless timeline.size == 0
      timeline_file = File.join(RAILS_ROOT, 'tmp', 'twitter_timeline.yml')
      last_id = begin
        (YAML.load_file timeline_file).first["id"]
      rescue
        -1
      end
      unless timeline.first["id"] == last_id
        File.open(timeline_file, "w") do |f|
          f.puts timeline.to_yaml
        end
        cached_file = File.join(RAILS_ROOT, 'public', 'index.html')
        File.delete(cached_file) if File.exists? cached_file
      end
    end
  end
end
