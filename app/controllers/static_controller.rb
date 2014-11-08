class StaticController < ApplicationController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    skip_filter :authenticate_user_from_token!, :authenticate_user!, only: [ :version ]

    def home
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