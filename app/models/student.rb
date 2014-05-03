class Student < ActiveRecord::Base
    include UserRole

    belongs_to :school_class

    validates :school_class_id, presence: true
    validates_with UserInheritingValidator
end
