require 'securerandom'
require 'yaml'

module Cloudi
    class SecretGenerator < Rails::Generators::NamedBase
        source_root File.expand_path('../templates', __FILE__)
        # this is to prevent rails generate from complaining about missing name
        argument :name, type: :string, default: "secret"

        def generate_secret
            secrets_hash = Hash.new
            [:development, :production, :test].each do |env|
                secrets_hash[env] = Hash.new
                secrets_hash[env][:secret_key_base] = ::SecureRandom.hex(64)
            end
            create_file "config/secrets.yml", secrets_hash.to_yaml
        end
    end
end
