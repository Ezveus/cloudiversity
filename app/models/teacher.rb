class Teacher < ActiveRecord::Base
    has_one :user, as: :role

    has_many :teacher_school_class_discipline, dependent: :destroy
    has_many :disciplines, through: :teacher_school_class_discipline
    has_many :school_classes, through: :teacher_school_class_discipline

    validates_with UserInheritingValidator
end
