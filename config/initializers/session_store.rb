# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_joakimbergman.se_session',
  :secret => '65b0ed4ad1e9116a399041f7af3af3ddcaeeb072b84df6de8a11cafdf8522c4bc208a7ffb3b06306a8d085e9e18dc2e49f92b5f1a735930f7b2a9c19b39096d0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
