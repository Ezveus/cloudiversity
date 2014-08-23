class PeriodPolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
        def resolve
            scope.all
        end
    end

    def create?
        user.is_admin?
    end

    def update?
        user.is_admin?
    end

    def destroy?
        user.is_admin?
    end

    def destroy_confirmation?
        destroy?
    end

    def set_current?
        update?
    end
end
