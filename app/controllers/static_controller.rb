class StaticController < ApplicationController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    skip_filter :authenticate_user_from_token!, :authenticate_user!, only: [ :version ]

    def home
        roles = current_user.roles.map(&:name)
        available_widgets = Cloudiversity::ModuleManager.modules.map do |mod|
            # select roles
            (mod.role_previews & roles).map do |r|
                "preview_#{mod.name.underscore}_#{r}" # cell name
            end
        end.flatten
        # TODO: preferences
        # user_widgets = current_user.widget_list_items.map{|wli| "preview_#{wli.name}"}
        # @widgets = (user_widgets & available_widgets).map(&:to_sym)
        @widgets = available_widgets
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
