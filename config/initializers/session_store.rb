# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_autoclubfcu.com_session',
  :secret      => 'f560198557d2b28d0e0c237f2f41e737227cd6e7643a46ebe265b8af7bfc43f8226d7ec0b2dcdcd3964ade0338bec271e47f4403bb835d96d3609c3bad6d6676'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
