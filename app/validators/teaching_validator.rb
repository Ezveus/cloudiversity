class TeachingValidator < ActiveModel::Validator
    def validate(record)
        teaching = Teaching.find_by(teacher_id: record.teacher_id,
                                    school_class_id: record.school_class_id,
                                    discipline_id: record.discipline_id)
        unless teaching.nil?
            record.errors[:teacher_id] = "is already teaching this discipline to this school class for this period"
        end
    end
end
