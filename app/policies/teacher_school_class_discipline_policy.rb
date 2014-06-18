class TeacherSchoolClassDisciplinePolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
        def resolve
            if user.is_student?
                return scope.where(school_class: user.as_student.school_class)
            elsif user.is_teacher?
                return scope.where(teacher: user.as_teacher)
            end

            raise Pundit::NotAuthorizedError
        end
    end
end
