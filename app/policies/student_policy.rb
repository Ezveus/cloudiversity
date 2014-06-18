class StudentPolicy < ApplicationPolicy
    def create?
        user.is_admin?
    end

    def destroy?
        user.is_admin?
    end

    class Scope < Struct.new(:user, :scope)
        def resolve
            scope
        end
    end
end
