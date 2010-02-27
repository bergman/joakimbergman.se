namespace :lastfm do
  task :artists => :environment do
    require 'open-uri'
    lastfm = YAML.load_file Rails.root.join('config', 'lastfm.yml')
    artists = ActiveSupport::JSON.decode(open("#{lastfm["api_url"]}?method=user.gettopartists&user=#{lastfm["user"]}&api_key=#{lastfm["api_key"]}&period=3month&format=json").read)["topartists"]["artist"]
    Artist.destroy_all
    artists.each do |a|
      Artist.create :name => a["name"], :plays => a["playcount"].to_i, :rank => a["@attr"]["rank"].to_i, :url => a["url"], :image => a["image"][2]["#text"].gsub('/126/', '/126s/')
    end
    File.delete(Rails.root.join('public', 'index.html')) if File.exists? Rails.root.join('public', 'index.html')
  end
  
  task :now_playing => :environment do
    require 'open-uri'
    lastfm = YAML.load_file Rails.root.join('config', 'lastfm.yml')
    artists = ActiveSupport::JSON.decode(open("#{lastfm["api_url"]}?method=user.getrecenttracks&user=#{lastfm["user"]}&api_key=#{lastfm["api_key"]}&limit=1&format=json").read)
    File.open(Rails.root.join('tmp', 'lastfm_now_playing.yml'), "w") {|f| f.puts artists.to_yaml }
    File.delete(Rails.root.join('public', 'index.html')) if File.exists? Rails.root.join('public', 'index.html')
  end
end

