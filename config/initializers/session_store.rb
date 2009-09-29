# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_foo_session',
  :secret      => 'e13b2ab4bf9f8412e3d4eae60b99b77817951dd4208cbfb664677bc0898c7560fab3084e63344f0f2d0d074dc665cb6cafba87aff8cf431491c0b4e1fa71ced2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
