# This migration comes from evaluations_engine (originally 20140630065142)
class CreateGradeGrades < ActiveRecord::Migration
    def change
        create_table :grade_grades do |t|
            t.string :assessment
            t.references :teacher_school_class_discipline, index: true
            t.references :student, index: true
            t.integer :coefficient, default: 1
            t.integer :note

            t.timestamps
        end
    end
end
