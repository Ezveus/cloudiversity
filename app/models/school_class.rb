class SchoolClass < ActiveRecord::Base
    include Handleable

    has_and_belongs_to_many :students
    has_many :teachings, dependent: :destroy
    has_many :teachers, through: :teachings
    has_many :disciplines, through: :teachings
    belongs_to :period

    # We want at least a non numeric character, so handles are useful
    validates :name, presence: true, format: /[^\d]/

    def to_s
        "#{name} (#{period.name})"
    end

    protected

    def generate_handle
        "#{name.parameterize}-#{period.handle}"
    end
end
