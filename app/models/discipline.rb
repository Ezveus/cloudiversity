class Discipline < ActiveRecord::Base
    include Handleable

    has_many :teachings, dependent: :destroy
    has_many :teachers, through: :teachings
    has_many :school_classes, through: :teachings
    has_many :periods, through: :teachings

    # We want at least a non numeric character, so handles are useful
    validates :name, format: /[^\d]/, presence: true, uniqueness: true

    protected

    def generate_handle
        name.parameterize
    end
end
