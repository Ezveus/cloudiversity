class TeachingPolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
        def resolve
            if user.roles.count > 1
                return Hash[user.roles.map { |role| [role.role_type.downcase,
                    send("get_#{role.role_type.downcase}_data")] }]
            elsif user.is_student?
                return get_student_data
            elsif user.is_teacher?
                return get_teacher_data
            elsif user.is_admin?
                return get_admin_data
            elsif user.is_parent?
                return get_parent_data
            end

            raise Pundit::NotAuthorizedError
        end

        # This method allows to raise a better exception for a missing role method
        def method_missing(m, *args, &block)
            if /get_(?<role_name>\w+)_data/ =~ m.to_s
                raise "The role #{role_name} doesn't exist or isn't managed by this policy"
            end
            super
        end

        private
        # Get all tscds apparented to a student
        def get_student_data
            scope.where(school_class: user.as_student.school_class)
        end

        # Get all tscds apparented to a teacher
        def get_teacher_data
            scope.where(teacher: user.as_teacher)
        end

        # Get all tscds apparented to an admin
        def get_admin_data
            scope.all
        end

        # Get all tscds apparented to a parent
        def get_parent_data
            [] # TODO: return right informations
        end
    end

    def show?
        !(record.nil? && user.roles.empty?) && user_can_see?
    end

    def index_per_tscd?
        show?
    end

    def update?
        user.is_admin?
    end

    def delete?
        user.is_admin?
    end

    private
    ## Returns true if the current user can see the record
    def user_can_see?
        return true if user.is_admin?
        (user.as_teacher.teachings.include?(record) if user.is_teacher?) ||
        (user.as_student.teacher_school_class_disciplines.include?(record) if user.is_student?)
        # TODO: Manage parent
    end
end
