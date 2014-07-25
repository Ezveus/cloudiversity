class TSCDValidator < ActiveModel::Validator
    def validate(record)
        tscd = TeacherSchoolClassDiscipline.find_by(teacher_id: record.teacher_id,
                                                    school_class_id: record.school_class_id,
                                                    discipline_id: record.discipline_id)
        unless tscd.nil?
            record.errors[:teacher_id] = "is already teaching this discipline to this school class"
        end
    end
end
