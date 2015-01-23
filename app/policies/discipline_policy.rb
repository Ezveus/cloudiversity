class DisciplinePolicy < ApplicationPolicy

    def create?
        user.is_admin?
    end

    def update?
        user.is_admin?
    end

    def destroy?
        user.is_admin?
    end

    class Scope < Struct.new(:user, :scope)
        def resolve
            scope.all
        end
    end
end
