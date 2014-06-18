class UserPolicy < ApplicationPolicy
    def index?
        user.is_admin?
    end

    def create?
        user.is_admin?
    end

    def update?
        user.is_admin?
    end

    def destroy?
        user.is_admin? && user != record
    end

    def show?
        user.present?
    end

    def reset_password?
        user.is_admin? and user != record
    end

    def unlock?
        reset_password?
    end

    class Scope < Struct.new(:user, :scope)
        def resolve
            scope.order('last_name, first_name')
        end
    end
end
