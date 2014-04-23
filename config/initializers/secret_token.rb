# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# Emulates rails 4.1 secret management
require 'yaml'
file = File.join("#{Rails.root}", 'config', 'secrets.yml')
secret_hash = if File.exists?(file)
                  YAML.load_file(file)
              else
                  nil
              end
env = Rails.env.to_sym

if secret_hash && secret_hash[env] && secret_hash[env][:secret_key_base]
    Cloudiversity::Application.config.secret_key_base = secret_hash[env][:secret_key_base]
else
    Cloudiversity::Application.config.secret_key_base = ''
    $stderr.puts 'Warning: secrets are not generated.','  Please use `rails g cloudi:secrets` to fix this problem.'
end
