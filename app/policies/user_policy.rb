class UserPolicy < ApplicationPolicy

    def create?
        user.is_admin?
    end

    def update?
        user.is_admin? || user == record
    end

    def destroy?
        user.is_admin? && user != record
    end

    class Scope < Struct.new(:user, :scope)
        def resolve
            scope.order('last_name, first_name')
        end
    end
end
