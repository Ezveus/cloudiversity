require 'securerandom'

module Cloudi
    class SecretGenerator < Rails::Generators::NamedBase
        source_root File.expand_path('../templates', __FILE__)
        # this is to prevent rails generate from complaining about missing name
        argument :name, type: :string, default: "secret"

        def generate_secret
            create_file "config/initializers/secret_token.rb", "Cloudiversity::Application.config.secret_key_base = '#{::SecureRandom.hex(64)}'"
        end
    end
end
