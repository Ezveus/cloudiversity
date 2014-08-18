class TeacherSchoolClassDiscipline < ActiveRecord::Base
    belongs_to :teacher
    belongs_to :school_class
    belongs_to :discipline
    belongs_to :period

    has_many :students, through: :school_class

    def school_class_discipline_name
        school_class.name + " - " + discipline.name
    end

    def teacher_discipline_name
        teacher.user.full_name + " - " + discipline.name
    end

    def school_class_teacher_name
        school_class.name + " - " + teacher.user.full_name
    end

    [Teacher, SchoolClass, Discipline, Period].each { |k| k.send(:alias_method, :tscd, :teacher_school_class_discipline) }
end
