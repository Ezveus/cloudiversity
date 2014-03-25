class User < ActiveRecord::Base
    devise :database_authenticatable,
        :rememberable, :trackable, :confirmable, :lockable

    validates :login, presence: true
    validates :email, presence: true, format: Devise.email_regexp
end
