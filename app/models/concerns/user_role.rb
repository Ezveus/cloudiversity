# @note Include this module in a role model

module UserRole
    extend ActiveSupport::Concern

    included do
        has_one :abstract_role, as: :role, dependent: :destroy
        has_one :user, through: :abstract_role

        ::User.register_role(name)
    end
end
