class StaticController < ApplicationController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    skip_filter :authenticate_entity_from_token!, :authenticate_entity!, only: [ :version ]

    def home
    end

    def admin
    end

    def version
        respond_to do |f|
            f.json { render json: {
                version: Cloudiversity::Version
            } }
        end
    end
end
