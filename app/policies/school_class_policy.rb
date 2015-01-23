class SchoolClassPolicy < ApplicationPolicy
    def create?
        user.is_admin?
    end

    def update?
        user.is_admin?
    end

    def destroy?
        user.is_admin?
    end

    def add?
        user.is_admin?
    end

    def list_students?
        !user.nil?
    end

    alias_method :add_new?, :add?
    alias_method :transfer?, :add?
    alias_method :add_proceed?, :add?

    class Scope < Struct.new(:user, :scope)
        def resolve
            scope.all
        end
    end
end
