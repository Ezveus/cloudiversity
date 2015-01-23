class Parent < ActiveRecord::Base
    include UserRole

    has_many :kinships
    has_many :students, through: :kinships

    validates_with UserInheritingValidator
end
