# @note Include this module in a role model

module UserRole
    extend ActiveSupport::Concern

    included do
        has_one :abstract_role, as: :role
        before_destroy :clean_abstract_role
        has_one :user, through: :abstract_role

        delegate :full_name, :login_full_name, :login, to: :user

        def clean_abstract_role
            self.abstract_role.destroy
        end
    end
end
