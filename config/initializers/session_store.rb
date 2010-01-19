# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_polyresolver_session',
  :expire_after => 2.hours,
  :secret      => '775363f3f99cb165b327b503ef71b1deaf212aeb90491aa9308c0810aa86e4edc1fb7470483ee6438b88134e30254b6e6792707d5c90af2b2e1c140d8fa36d63'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
