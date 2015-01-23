class Exercices::Exercice < ActiveRecord::Base
    belongs_to :teacher_school_class_discipline
    belongs_to :exercice_type, polymorphic: true

    validates_presence_of :start_date, :end_date, :is_graduated
end

::TeacherSchoolClassDiscipline.send(:has_many, :exercices_exercice, class_name: 'Exercices::Exercice')
