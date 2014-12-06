class Teacher < ActiveRecord::Base
    include UserRole

    has_many :teachings, dependent: :destroy
    has_many :disciplines, through: :teachings
    has_many :school_classes, through: :teachings
    has_many :periods, through: :school_classes
end
