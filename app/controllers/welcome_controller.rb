class WelcomeController < ApplicationController
  caches_page :index
  
  def index
    @artists = Artist.all :order => :rank, :limit => 8
    @tweet = Tweet.last :order => :status_id
  end
end
