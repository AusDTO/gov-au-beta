# Configure SSL and HSTS options

# HSTS WARNING:
# (a) We do *NOT* want to include subdomains because many of our subdomains do not support https
# (b) We do *NOT* want to preload because it implies we're including subdomains
# (c) While still in development, keep the expiry low in case it needs to be changed
# (d) To disable HSTS, set `hsts: false` to set the expiry to zero and clear HSTS caching in browsers

# See http://api.rubyonrails.org/classes/ActionDispatch/SSL.html

Rails.application.config.ssl_options = { hsts: { subdomains: false, preload: false, expires: 1.days } }
