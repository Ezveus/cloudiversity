class Admin < ActiveRecord::Base
    include UserRole
    validates_with UserInheritingValidator
end
