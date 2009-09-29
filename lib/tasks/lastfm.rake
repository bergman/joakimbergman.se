namespace :lastfm do
  task :artists => :environment do
    require 'open-uri'
    lastfm = YAML.load_file File.join(RAILS_ROOT, 'config', 'lastfm.yml')
    artists = ActiveSupport::JSON.decode(open("#{lastfm["api_url"]}?method=user.gettopartists&user=#{lastfm["user"]}&api_key=#{lastfm["api_key"]}&period=overall&format=json").read)
    File.open(File.join(RAILS_ROOT, 'tmp', 'lastfm_artists.yml'), "w") {|f| f.puts artists.to_yaml }
    ActionController::Base::expire_page('/')
  end
end

