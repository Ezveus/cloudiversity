class Student < ActiveRecord::Base
    include UserRole

    has_and_belongs_to_many :school_classes
    has_many :kinships
    has_many :parents, through: :kinships
end
