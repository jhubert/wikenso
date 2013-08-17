# Be sure to restart your server when you modify this file.

Wikenso::Application.config.session_store :cookie_store, key: '_wikenso_session', :domain => ENV["host_name"]
