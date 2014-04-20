# == Schema Information
#
# Table name: users
#
#  login
#  email
#  first_name
#  last_name
#

require 'spec_helper'

describe User do
    before(:each) do
        @user_attributes = FactoryGirl.attributes_for(:user)
    end

    it "should create a new instance of User with valids attributes" do
        User.create!(@user_attributes)
    end

    describe "Login tests" do
        it "should need a login" do
            bad_guy = User.new(@user_attributes.merge(login: ""))
            bad_guy.should_not be_valid
        end

        it "should reject too short login" do
            short_login = "a"
            short_login_user = User.new(@user_attributes.merge(login: short_login))
            short_login_user.should_not be_valid
        end

        it "should reject a non-unique login" do
            User.create!(@user_attributes)
            user_with_duplicate_login = User.new(@user_attributes.merge(email: "another@valid.email"))
            user_with_duplicate_login.should_not be_valid
        end
    end

    describe "Email tests" do
        it "should need an email" do
            bad_guy = User.new(@user_attributes.merge(email: ""))
            bad_guy.should_not be_valid
        end

        it "should reject unvalid email" do
            invalid_email_user = User.new(@user_attributes.merge(email: "user_at_foo.org"))
            invalid_email_user.should_not be_valid
        end

        it "should reject a non-unique email (case insensitive)" do
            upcased_email = @user_attributes[:email].upcase
            User.create!(@user_attributes.merge(email: upcased_email,
                         login: "User 1"))
            user_with_duplicate_email = User.new(@user_attributes.merge(login: "User 2"))
            user_with_duplicate_email.should_not be_valid
        end
    end

    describe "Name tests" do
        it "should have a first name" do
            bad_guy = User.new(@user_attributes.merge(first_name: ""))
            bad_guy.should_not be_valid
        end

        it "should have a last name" do
            bad_guy = User.new(@user_attributes.merge(last_name: ""))
            bad_guy.should_not be_valid
        end

        it "should respond to full_name" do
            guy = User.new(@user_attributes)
            guy.respond_to? :full_name
        end

        it "should have following full name: first_name last_name" do
            guy = User.new(@user_attributes)
            guy.full_name == guy.first_name + " " + guy.last_name
        end
    end
end
