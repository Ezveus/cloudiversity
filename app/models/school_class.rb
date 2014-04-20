class SchoolClass < ActiveRecord::Base
    has_many :students, dependent: :destroy
    has_many :teacher_school_class_discipline, dependent: :destroy
    has_many :teachers, through: :teacher_school_class_discipline
    has_many :disciplines, through: :teacher_school_class_discipline

    validates :name, presence: true
end
