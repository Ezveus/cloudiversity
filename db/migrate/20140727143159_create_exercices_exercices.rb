class CreateExercicesExercices < ActiveRecord::Migration
    def change
        create_table :exercices_exercices do |t|
            t.date :start_date
            t.date :end_date
            t.boolean :is_graduated
            t.references :teacher_school_class_discipline, index: true
            t.references :exercice_type, index: true, polymorphic: true

            t.timestamps
        end
    end
end
