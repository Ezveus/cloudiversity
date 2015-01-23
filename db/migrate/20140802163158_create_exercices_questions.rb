class CreateExercicesQuestions < ActiveRecord::Migration
    def change
        create_table :exercices_questions do |t|
            t.boolean :availability_mode
            t.time :timer
            t.text :wording
            t.references :MCQ, index: true

            t.timestamps
        end
    end
end
