class ApplicationController < ActionController::Base
    acts_as_token_authentication_handler_for User

    include Pundit
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :null_session

    after_action :verify_authorized, :except => :index, unless: :devise_controller?
    after_action :verify_policy_scoped, :only => :index, unless: :devise_controller?

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    # Manages multirole indirection. Will provide an helper object to build the
    # multirole context, and will build the view according to the code passed
    # through the +MultiroleContext+ and partials.
    def multirole(&block)
        # Turn off pundit's checks for +authorize+ and +policy_scope+, because
        # we can't use them raw in the roles (role specialization) and since
        # (for HTML) we call controller code from the view generation, pundit
        # checks would prevent us from rendering the view before the "liberating"
        # code... For multirole, we can currently agree that the users will
        # be careful enough...
        if params[:action].to_sym == :index
            @_policy_scoped = true
        else
            @_policy_authorized = true
        end

        # Preparation step: execute the top-level code for +multirole+ to
        # gather needed data (see +MultiroleContext+ for more informations).
        # Pass a context object (eh) that allows to build the controller.
        ctx = MultiroleContext.new
        block.call(ctx)

        # We get the needed data from the context, then we determine which roles
        # among the ones declared by the controller are applicable to our current
        # user.
        roles = ctx.instance_variable_get(:@roles)
        json_roles = ctx.instance_variable_get(:@json_roles)
        matched_roles = current_user.roles.map { |role| role.role_type.underscore.to_sym } & roles.keys

        # Too bad.
        raise Pundit::NotAuthorizedError if matched_roles.empty?

        respond_to do |format|
            # We always render HTML. We begin by rendering a view like in conventionnal
            # actions (based on action name); the difference is that the view will
            # have access to +roles+, a special object that will allow to build the
            # multirole view. (See +MultiroleHelper+)
            format.html { render locals: { roles: MultiroleHelper.new(self, roles.slice(*matched_roles)) } }

            # If the role called +MultiroleContext#json+, we allow json rendering.
            # JSON rendering will check for unique role (either because one role
            # match or by +as+ parameter).
            format.json do
                if matched_roles.count > 1 and not params.include?(:as)
                    # We can't serve JSON for multirole without knowing which
                    # one the client wants.
                    render json: { error: "Ambiguous role" }, status: 300 # 300 = Multiple Choices
                else
                    # Get the current role
                    role =  if params.include?(:as)
                                matched_roles.include?(params[:as].to_sym) ? params[:as] : nil
                            else
                                matched_roles.first
                            end
                    render(json: { error: "Invalid role" }, status: 400) and return if role.nil?

                    roles[role.to_sym].call current_user.send("as_#{role}")
                    blk = ctx.instance_variable_get(:@json_object) # Call the controller code for role
                    render(json: { error: "You must call `MultiroleContext#json` in the roles where " +
                                   "you want to render JSON" }, status: 500) and return if blk.nil?

                    # The rendered JSON is given by the block return.
                    render json: blk.call
                end
            end unless (json_roles & matched_roles).empty? or (params.include?(:as) and not json_roles.include?(params[:as].to_sym))
        end
    end

    private

    # The role action builder. Will provide methods and store informations to
    # build the multiview action that +multirole+ will use to build the final
    # result.
    class MultiroleContext
        # Creates the context with empty values.
        def initialize
            @roles = {}
            @json_roles = []
            @json_object = nil
        end

        # Indicates which roles respond to JSON. For the roles you will indicate
        # to +json_for+, you must call +MultiroleContext#json+ to provide data
        # that will be JSONified.
        def json_for(*roles)
            @json_roles += roles
        end

        # In a role block, sets which data will be JSONified. See +json_for+.
        def json(&blk)
            @json_object = blk
        end

        # Used to dynamically generate methods for roles. You can call
        # on the object any method corresponding to an underscore'd
        # role name. If it matches, this will save the block for
        # the given role. The block takes one argument, the
        # specialized user.
        def method_missing(method, *args, &block)
            begin
                return super(method, args, block) unless method.to_s.classify.constantize.ancestors.include? UserRole
            rescue # Class not found
                return super(method, args, block)
            end

            @roles[method.to_sym] = block
        end
    end

    # The "Helper" object passed to the view. (Not a helper at
    # the rails way, but anyway.) It provides methods used
    # to build the views.
    class MultiroleHelper
        # Create a new helper. Used by the controller.
        def initialize(controller, matched_roles)
            @controller = controller
            # It's an older code, but it checks out
            @user = controller.send(:current_user)
            @action = controller.send(:params)[:action]
            @matched_roles = matched_roles
            @cur_role = nil
        end

        # Indicates if we're in a multirole situation.
        def multiple?
            @matched_roles.count > 1
        end

        # Renders the given view block for each role. Used
        # with +render+ to generate view. Better use it once,
        # +each_role+ is here to iterate other roles without
        # rendering instead.
        def each(&view)
            @matched_roles.each do |role, blk|
                @cur_role = role
                view.call(role)
                @cur_role = nil
            end
        end

        # Render a partial from multirole mode. Can be used alone when
        # in mono-role mode, must be used inside of +MultiroleHelper#each+
        # when in multi-role mode. Will call the current role's controller
        # code and then render the view.
        def render(view)
            role = multiple? ? @cur_role : @matched_roles.keys.first
            raise "You must use render in each_role when rendering in multirole mode" if role.nil?

            rolified = @user.send("as_" + role.to_s)
            view.instance_exec(rolified, &@matched_roles[role])
            view.send(:render, { partial: "#{@action}_#{role}", locals: { role => rolified } })
        end

        # Iterate other matched roles, taking a block that takes a specialized role.
        def each_role(&blk)
            @matched_roles.map do |role, prep|
                rolified = @user.send("as_" + role.to_s)
                blk.call(rolified)
            end.join
        end
    end

    def user_not_authorized(exception)
        policy_name = exception.policy.class.to_s.underscore

        flash[:alert] = I18n.t "pundit.#{policy_name}.#{exception.query}",
        default: 'You cannot perform this action.' # You shall not pass
        redirect_to(request.referrer || root_path)
    end
end
