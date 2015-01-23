module Cloudiversity
    Version = if Rails.env.test?
                  'test'
              elsif Rails.env.development?
                  'dev-' + `git rev-parse HEAD`.slice(0, 10)
              else
                  # Update me on release
                  '0.1.0'
              end
end
