class User < ActiveRecord::Base
    acts_as_token_authenticatable

    devise :database_authenticatable,
        :rememberable, :trackable, :lockable,
        :recoverable

    has_many :abstract_roles

    mount_uploader :avatar, AvatarUploader

    validates :login,
        presence: true,
        length: { minimum: 6 },
        uniqueness: true,
        format: /\A[a-z][\w\.-]+\z/i
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email,
        presence: true,
        format: /\A.+@.+\..+\z/,
        uniqueness: { case_sensitive: false }
    validates :password,
        confirmation: true,
        length: { in: 8..64 },
        unless: Proc.new { |u| u.password.blank? }
    validates :password_confirmation,
        presence: true,
        unless: Proc.new { |u| u.password.nil? }

    self.per_page = 10

    # Automatically formats the name of the user to include both first and last name in a standardized way.
    # @return [String]
    def full_name
        "#{last_name}, #{first_name}"
    end

    # Indicates if an user has a password.
    def password_set?
        encrypted_password?
    end

    # Indicates if the user has a password reset pending.
    def reset_pending?
        # Devise resets reset_password_sent_at but not reset_password_token.
        reset_password_sent_at?
    end

    # Indicates if the user has a password reset pending, and if it is expired.
    def reset_expired?
        reset_password_sent_at? and not reset_password_period_valid?
    end

    # Indicates if (given the fact he has his current password) a user would be able to log in.
    def good?
        password_set? and not locked_at?
    end

    def login_full_name
        login + " - " + full_name
    end

    # Returns a list of roles attributed to the user.
    alias_method :roles, :abstract_roles

    # Allow to refer to the user as one of its role dynamically. Implements a series of +as_role+ and +is_role?+
    # functions to be able to get the specialized role or check if a user responds to a role dynamically.
    def method_missing(m, *args, &block)
        @@roles = User.app_roles
        if /is_(?<role__name>\w+)\?/ =~ m.to_s
            role__name.capitalize!
            if @@roles.include?(role__name)
                return roles.map{|r| r.role_type}.include? role__name
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

    # Reimplementing the param generation to use the login instead of the id as key.
    # @return [String] The same as +login+.
    def to_param
        login
    end

    # Reimplementing standard +find+ to be able to find by both login and
    # id.
    # Just check if the parameter looks like an id (first character is a
    # number) and sends back to standard +find+ or, if it's a login, uses
    # +find_by+.
    # @return [User] The matched user, if any. Throws an exception if the user is not found.
    def self.find(id)
        if id.to_s =~ /\A\d/
            super id
        else
            find_by! login: id
        end
    end

    def to_json
        {
            id: id,
            login: login,
            first_name: first_name,
            last_name: last_name,
            email: email,
            roles: roles.map do |role|
                role.role_type
            end
        }.to_json
    end

    # Allows to get a list of all available roles in the application.
    def self.app_roles
        @@roles ||= ActiveRecord::Base.connection.tables.map do |model|
            model.capitalize.singularize.camelize
        end.select do |model|
            begin
                eval "#{model}.ancestors.include? UserRole"
            rescue
                false
            end
        end
    end

    protected

    def password_required?
        encrypted_password? and (not password.nil? or not password_confirmation.nil?)
    end
end
