## Copied from devise wiki
#===============================================================
module ControllerHelpers
    def sign_in(user = double('user'))
        if user.nil?
            request.env['warden'].stub(:authenticate!).
                and_throw(:warden, {:scope => :user})
            controller.stub :current_user => nil
        else
            request.env['warden'].stub :authenticate! => user
            controller.stub :current_user => user
        end
    end


end

RSpec.configure do |config|
    config.include Devise::TestHelpers, :type => :controller
    config.include ControllerHelpers, :type => :controller
end
#===============================================================

module SpecControllerHelpers
    def success_and_authorization_tests(group, args = {})
        raise "No action given" if args[:action].nil?
        raise "No verb given" if args[:verb].nil?

        group.instance_eval do
            it "returns http success" do
                send(args[:verb], args[:action], args[:params])
                response.should be_success
            end

            it "should redirect non-admin users" do
                sign_in
                send(args[:verb], args[:action], args[:params])
                response.should redirect_to(root_path)
            end

            it "should force to sign in" do
                sign_in nil
                send(args[:verb], args[:action], args[:params])
                response.should redirect_to(new_user_session_path)
            end

            it "should be accessible if logged" do
                sign_in @admin
                send(args[:verb], args[:action], args[:params])
                r = response
                # if args[:params][:teacher]
                    # puts("response: #{r.inspect}")
                    # puts("response.success?: #{r.status}")
                # end
                r.should be_success
            end
        end
    end
end
