namespace :twitter do
  task :timeline => :environment do
    require 'open-uri'
    twitter = YAML.load_file File.join(RAILS_ROOT, 'config', 'twitter.yml')
    last_id = begin
      (YAML.load_file File.join(RAILS_ROOT, 'tmp', 'twitter_timeline.yml')).first["id"]
    rescue
      1
    end
    timeline = ActiveSupport::JSON.decode(open("http://twitter.com/statuses/user_timeline/#{twitter["user"]}.json?count=1&since_id=#{last_id}").read)
    unless timeline.size == 0
      File.open(File.join(RAILS_ROOT, 'tmp', 'twitter_timeline.yml'), "w") {|f| f.puts timeline.to_yaml }
      ActionController::Base::expire_page('/')
    end
  end
end
