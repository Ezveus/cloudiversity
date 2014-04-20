class Student < ActiveRecord::Base
    has_one :user, as: :role
    belongs_to :school_class

    validates :school_class_id, presence: true
    validates_with UserInheritingValidator
end
