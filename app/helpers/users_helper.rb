module UsersHelper
    def user_status(user)
        css = 'uk-text-success'
        text = 'OK'

        if user.password_set?
            if user.locked_at?
                css = 'uk-text-danger'
                text = 'Locked'
            elsif user.reset_pending?
                if user.reset_expired?
                    css = ''
                    text = 'Password reset expired'
                else
                    css = 'uk-text-warning'
                    text = 'Password reset pending'
                end
            end
        else
            if user.reset_pending?
                if user.reset_expired?
                    css = ''
                    text = 'Password reset expired'
                else
                    css = 'uk-text-warning'
                    text = 'Password reset pending'
                end
            else
                css = 'uk-text-warning'
                text = 'Uninitialized account'
            end
        end

        content_tag :dd, class: css do
            text
        end
    end

    # Just get a list of the user roles, separated by commas, or "No role"
    def role(user)
        if user.roles.count > 0
            user.roles.map { |role| role.role_type }.join ', '
        else
            'No roles'
        end
    end
end
