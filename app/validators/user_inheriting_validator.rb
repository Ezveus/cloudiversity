class UserInheritingValidator < ActiveModel::Validator
    def validate(record)
        if record.user.nil? || User.where(id: record.user.id).first.nil?
            record.errors[:user] = "should be a valid user present in database"
        elsif User.find(record.user.id).role
            record.errors[:user] = "is already taken"
        end
    end
end
