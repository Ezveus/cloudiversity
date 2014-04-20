class CreateDiscipline < ActiveRecord::Migration
  def change
    create_table :disciplines do |t|
      t.string :name
    end
  end
end
