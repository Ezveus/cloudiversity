# @note Include this module in a role model

module UserRole
    extend ActiveSupport::Concern

    included do
        has_one :abstract_role, as: :role, dependent: :destroy
        has_one :user, through: :abstract_role

        delegate :full_name, :login_full_name, :login, to: :user
    end
end
