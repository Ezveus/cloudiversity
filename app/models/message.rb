class Message < ActiveRecord::Base
	belongs_to :user
	belongs_to :commentable, polymorphic: true
	belongs_to :deleted_by, class_name: 'User'

	validates :content, presence: true
    validates :commentable, presence: true
    validates :user, presence: true

    def deleted?
        deleted_by.nil? ? false : true
    end
end
