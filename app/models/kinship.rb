class Kinship < ActiveRecord::Base
  belongs_to :parent
  belongs_to :student

  validates :parent_id, presence: true
  validates :student_id, presence: true
end
