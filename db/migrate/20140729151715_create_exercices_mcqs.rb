class CreateExercicesMcqs < ActiveRecord::Migration
    def change
        create_table :exercices_mcqs do |t|
        t.boolean :allow_blank
        t.integer :blank_point
        t.integer :correct_point
        t.boolean :multiple
        t.integer :number_of_question
        t.integer :training_number
        t.integer :wrong_points

        t.timestamps
        end
    end
end
