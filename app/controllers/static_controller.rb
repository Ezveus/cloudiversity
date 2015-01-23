class StaticController < ApplicationController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    skip_filter :authenticate_user_from_token!, :authenticate_user!, only: [ :version ]

    def home
        respond_to do |format|
            format.html do
                roles = current_user.roles_names
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
            format.json do
                role = params[:as] if current_user.roles_names.include? params[:as]

                if role
                    # TODO: return real data
                    render json: {ok: :ok}
                else
                    if params[:as] # TODO: remove default
                        render json: {error: t('api.errors.invalid_role', default: 'invalid_role')}, status: :forbidden
                    else # TODO: remove default
                        render json: {error: t('api.errors.role_missing', default: 'role_missing')}, status: :bad_request
                    end
                end
            end
        end
    end

    def update_widget_order
        respond_to do |format|

        end
    end

    def admin
        raise Pundit::NotAuthorizedError unless current_user.is_admin?

        @students       = Student.all
        @school_classes = SchoolClass.all
        @disciplines    = Discipline.all
        @teachers       = Teacher.all
        @periods        = Period.current
    end

    def version
        respond_to do |f|
            json = { version: Cloudiversity::Version }
            json.merge!({ modules: Cloudiversity::ModuleManager.modules.map(&:name) }) unless current_user.nil?

            f.json { render json: json }
        end
    end

    def locale
        cookies[:lang] = { value: params[:locale], expires: 1.year.from_now, path: '/' }
        redirect_to request.referrer || root_path
    end
end