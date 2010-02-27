namespace :twitter do
  task :timeline => :environment do
    require 'open-uri'
    twitter_user = (YAML.load_file Rails.root.join('config', 'twitter.yml'))["user"]
    timeline = ActiveSupport::JSON.decode(open("http://twitter.com/statuses/user_timeline/#{twitter_user}.json").read)
    if timeline.size > 0
      t = timeline.first
      unless Tweet.last and t["id"] == Tweet.last.id
        Tweet.create :status_id => t["id"], :in_reply_to_user_id => t["in_reply_to_user_id"], :in_reply_to_status_id => timeline.first["in_reply_to_status_id"], :in_reply_to_screen_name => timeline.first["in_reply_to_screen_name"], :text => timeline.first["text"], :tweeted_at => t["created_at"]
        cached_file = Rails.root.join('public', 'index.html')
        File.delete(cached_file) if File.exists? cached_file
      end
    end
  end
end
