class UserInheritingValidator < ActiveModel::Validator
    def validate(record)
        if record.user && record.user.roles.map(&:role_type).include?(record.class.to_s)
            record.errors[:user] = "already has this role"
        end
    end
end
