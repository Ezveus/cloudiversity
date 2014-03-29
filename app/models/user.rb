class User < ActiveRecord::Base
    devise :database_authenticatable,
        :rememberable, :trackable, :confirmable, :lockable

    belongs_to :school_class

    validates :login, presence: true
    validates :email, presence: true, format: Devise.email_regexp
    validates :first_name, presence: true
    validates :last_name, presence: true

    def full_name
        first_name + " " + last_name
    end
end
