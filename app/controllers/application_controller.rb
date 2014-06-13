class ApplicationController < ActionController::Base
    acts_as_token_authentication_handler_for User

    include Pundit
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :null_session

    after_action :verify_authorized, :except => :index, unless: :devise_controller?
    after_action :verify_policy_scoped, :only => :index, unless: :devise_controller?

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized(exception)
        policy_name = exception.policy.class.to_s.underscore

        flash[:alert] = I18n.t "pundit.#{policy_name}.#{exception.query}",
        default: 'You cannot perform this action.' # You shall not pass
        redirect_to(request.referrer || root_path)
    end
end
