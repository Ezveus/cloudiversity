class User < ActiveRecord::Base
    acts_as_token_authenticatable

    devise :database_authenticatable,
        :rememberable, :trackable, :lockable,
        :validatable, :recoverable

    has_many :abstract_roles

    validates :login, presence: true, length: { minimum: 6 }, uniqueness: true
    validates :first_name, presence: true
    validates :last_name, presence: true

    def full_name
        first_name + " " + last_name
    end

    # Password, reset, stuff. Better done here than in the view.
    # Has a password ever been set ?
    def password_set?
        encrypted_password?
    end

    # Is a password reset pending ?
    def reset_pending?
        # Devise resets reset_password_sent_at but not reset_password_token.
        reset_password_sent_at?
    end

    # If a password reset is pending, has it expired ?
    def reset_expired?
        reset_password_sent_at? and not reset_password_period_valid?
    end

    def login_full_name
        login + " - " + full_name
    end

    def self.register_role(role_name)
        @@roles ||= []
        unless @@roles.include?(role_name)
            @@roles.append(role_name)
        end
    end

    def roles
        abstract_roles
    end

    def method_missing(m, *args, &block)
        if /is_(?<role_name>\w+)\?/ =~ m.to_s
            role_name.capitalize!
            if @@roles.include?(role_name)
                return roles.map{|r| r.role_type}.include? role_name
            end
        elsif /as_(?<role_name>\w+)/ =~ m.to_s
            role_name.capitalize!
            if @@roles.include?(role_name)
                ar = roles.select{|r| r.role_type == role_name}.first
                if ar
                    return ar.role
                else
                    return nil
                end
            end
        end
        super
    end

    protected

    def password_required?
        encrypted_password? and (not password.nil? or not password_confirmation.nil?)
    end
end
