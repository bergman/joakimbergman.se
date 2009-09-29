class WelcomeController < ApplicationController
  caches_page :index
  
  def index
    @lastfm_artists = (YAML.load_file File.join(RAILS_ROOT, 'tmp', 'lastfm_artists.yml'))["topartists"]["artist"][0..7]
    @tweet = (YAML.load_file File.join(RAILS_ROOT, 'tmp', 'twitter_timeline.yml')).first["text"]
  end
end
