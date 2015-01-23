class CreateExercicesChoices < ActiveRecord::Migration
    def change
        create_table :exercices_choices do |t|
            t.string :choice
            t.boolean :is_correct
            t.references :Question, index: true

            t.timestamps
        end
    end
end
