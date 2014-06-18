class TeacherPolicy < ApplicationPolicy
    def index?
        user.is_admin? || user.is_teacher?
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

    def assign?
        update?
    end

    class Scope < Struct.new(:user, :scope)
        def resolve
            scope.all
        end
    end
end
