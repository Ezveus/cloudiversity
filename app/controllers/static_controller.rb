class StaticController < ApplicationController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    skip_filter :authenticate_entity_from_token!, :authenticate_entity!, only: [ :version ]

    def home
    end

    def admin
        raise Pundit::NotAuthorizedError unless current_user.is_admin?
    end

    def version
        respond_to do |f|
            f.json { render json: {
                version: Cloudiversity::Version
            } }
        end
    end
end
