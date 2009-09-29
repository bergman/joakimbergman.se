namespace :lastfm do
  task :artists => :environment do
    require 'open-uri'
    lastfm = YAML.load_file File.join(RAILS_ROOT, 'config', 'lastfm.yml')
    artists = ActiveSupport::JSON.decode(open("http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=#{lastfm["user"]}&api_key=#{lastfm["api_key"]}&period=overall&format=json").read).to_yaml
    file = File.open(File.join(RAILS_ROOT, 'tmp', 'lastfm_artists.yml'), "w")
    file.puts(artists)
    file.close
  end
end

