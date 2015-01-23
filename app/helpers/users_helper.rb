module UsersHelper
    def user_status(user, color = true)
        css = 'uk-text-success'
        text = :ok

        if user.password_set?
            if user.locked_at?
                css = 'uk-text-danger'
                text = :locked
            elsif user.reset_pending?
                if user.reset_expired?
                    css = ''
                    text = :reset_expired
                else
                    css = 'uk-text-warning'
                    text = :reset_pending
                end
            end
        else
            if user.reset_pending?
                if user.reset_expired?
                    css = ''
                    text = :reset_expired
                else
                    css = 'uk-text-warning'
                    text = :reset_pending
                end
            else
                css = 'uk-text-warning'
                text = :uninitialized
            end
        end

        if color
            content_tag :dd, class: css do
                t("users.status.#{text.to_sym}")
            end
        else
            t("users.status.#{text.to_sym}")
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
