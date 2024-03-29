class AbstractRole < ActiveRecord::Base
    belongs_to :user
    belongs_to :role, polymorphic: true

    validates :user, presence: true
    validates :role, presence: true
end
