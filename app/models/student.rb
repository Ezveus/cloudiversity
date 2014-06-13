class Student < ActiveRecord::Base
    include UserRole

    belongs_to :school_class

    has_many :kinships
    has_many :parents, through: :kinships

    validates :school_class_id, presence: true
    validates_with UserInheritingValidator
end
