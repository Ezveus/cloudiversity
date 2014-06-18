class AdminPolicy < ApplicationPolicy
    def create?
        user.is_admin?
    end

    def destroy?
        user.is_admin? && user.as_admin != record
    end

    class Scope < Struct.new(:user, :scope)
        def resolve
            scope
        end
    end
end
