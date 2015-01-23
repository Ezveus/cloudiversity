class CreateExercicesClozeTexts < ActiveRecord::Migration
    def change
        create_table :exercices_cloze_texts do |t|
        t.string :text

        t.timestamps
        end
    end
end
