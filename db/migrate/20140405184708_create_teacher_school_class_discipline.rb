class CreateTeacherSchoolClassDiscipline < ActiveRecord::Migration
  def change
    create_table :teacher_school_class_disciplines do |t|
      t.references :teacher, index: true
      t.references :school_class, index: true
      t.references :discipline, index: true
    end
  end
end
