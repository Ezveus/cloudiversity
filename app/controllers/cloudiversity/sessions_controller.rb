class Cloudiversity::SessionsController < Devise::SessionsController
    def create
        self.resource = warden.authenticate!(auth_options)
        set_flash_message(:notice, :signed_in) if is_flashing_format?
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_to do |format|
            format.html do
                respond_with resource, location: after_sign_in_path_for(resource)
            end

            format.json do
                render json: { success: true, email: resource.email, token: resource.authentication_token }
            end
        end
    end
end
