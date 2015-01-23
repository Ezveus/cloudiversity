class Student < ActiveRecord::Base
    include UserRole

    belongs_to :school_class

    has_many :kinships
    has_many :parents, through: :kinships

    has_many :teacher_school_class_disciplines, through: :school_class

    validates :school_class_id, presence: true
    validates_with UserInheritingValidator
end
