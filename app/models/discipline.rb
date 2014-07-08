class Discipline < ActiveRecord::Base
    has_many :teacher_school_class_discipline, dependent: :destroy
    has_many :teachers, through: :teacher_school_class_discipline
    has_many :school_classes, through: :teacher_school_class_discipline
    has_many :periods, through: :teacher_school_class_discipline
end
