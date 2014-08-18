# This migration comes from evaluations_engine (originally 20140627102224)
class CreateGradeAssessments < ActiveRecord::Migration
    def change
        create_table :grade_assessments do |t|
            t.string :assessment
            t.boolean :school_class_assessment, default: false
            t.references :teacher_school_class_discipline, index: true
            t.references :student, index: true

            t.timestamps
        end
    end
end
