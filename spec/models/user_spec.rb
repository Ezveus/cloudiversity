require 'spec_helper'

describe User do
    before(:each) do
        @user_attributes = FactoryGirl.attributes_for(:user)
    end

    it 'should create a valid user' do
        create(:user)
    end

    it 'should use its login to identify itself' do
        build(:user).tap do |user|
            expect(user.to_param).to eq(user.login)
        end
    end

    it 'should be searchable by index and by login' do
        create(:user).tap do |user|
            expect(User.find(user.id)).to eq(user)
            expect(User.find(user.login)).to eq(user)
        end
    end

    describe 'login' do
        it 'should require a login' do
            build(:user).tap do |user|
                user.login = nil
                expect(user).not_to be_valid
            end
        end

        it 'should reject short logins' do
            build(:user).tap do |user|
                user.login = user.login[0, 7]
                expect(user).to be_valid

                user.login = user.login[0, 6]
                expect(user).to be_valid

                user.login = user.login[0, 5]
                expect(user).not_to be_valid
            end
        end

        it 'should reject non-unique logins' do
            create(:user).tap do |user|
                build(:user).tap do |copycat|
                    copycat.login = user.login
                    expect(copycat).not_to be_valid

                    copycat.login = user.login.swapcase
                    expect(copycat).not_to be_valid
                end
            end
        end

        it 'should reject invalid formats' do
            build(:user).tap do |user|
                %w{
                    0abcdef
                    _abcdef
                    -abcdef
                    accentué
                    me@example.org
                    (%@:;,.?)
                }.each do |bad_login|
                    user.login = bad_login
                    expect(user).not_to be_valid
                end
            end
        end
    end

    describe 'email' do
        it 'requires an email' do
            build(:user).tap do |user|
                user.email = nil
                expect(user).not_to be_valid
            end
        end

        it 'should reject invalid email' do
            build(:user).tap do |user|
                user.email = Faker::Internet.user_name(user.full_name, %w(-))
                expect(user).not_to be_valid
            end
        end

        it 'should reject non-unique emails' do
            create(:user).tap do |user|
                build(:user).tap do |copycat|
                    copycat.email = user.email
                    expect(copycat).not_to be_valid

                    copycat.email = user.email.swapcase
                    expect(copycat).not_to be_valid
                end
            end
        end
    end

    describe 'name' do
        it 'should have a name' do
            build(:user).tap do |user|
                user.last_name = nil
                user.first_name = nil
                expect(user).not_to be_valid

                user.last_name = Faker::Name.last_name
                expect(user).not_to be_valid

                user.last_name = nil
                user.first_name = Faker::Name.first_name
                expect(user).not_to be_valid
            end
        end

        it 'should determine a valid full name' do
            build(:user).tap do |user|
                expect(user.full_name).to eq("#{user.last_name}, #{user.first_name}")
            end
        end
    end

    describe 'password' do
        it 'should allow creating a user without password' do
            build(:user).tap do |user|
                user.password = nil
                expect(user).to be_valid
            end
        end

        it 'should require password confirmation if set' do
            build(:user).tap do |user|
                user.password = Faker::Internet.password(10, 10)
                user.password_confirmation = nil
                expect(user).not_to be_valid

                user.password_confirmation = user.password
                expect(user).to be_valid
            end
        end

        it 'should require password to be a correct length' do
            build(:user).tap do |user|
                user.password = Faker::Internet.password(7, 7)
                user.password_confirmation = user.password
                expect(user).not_to be_valid

                user.password = Faker::Internet.password(8, 8)
                user.password_confirmation = user.password
                expect(user).to be_valid

                user.password = Faker::Internet.password(64, 64)
                user.password_confirmation = user.password
                expect(user).to be_valid

                user.password = Faker::Internet.password(65, 65)
                user.password_confirmation = user.password
                expect(user).not_to be_valid
            end
        end

        it 'should require a confirmation on change' do
            build(:user).tap do |user|
                user.password = Faker::Internet.password(8, 10)
                user.password_confirmation = ''
                expect(user).not_to be_valid

                user.password_confirmation = Faker::Internet.password(8, 10) until user.password != user.password_confirmation
                expect(user).not_to be_valid

                user.password_confirmation = user.password
                expect(user).to be_valid
            end
        end
    end

    describe 'helpers' do
        it 'should report correct password status' do
            build(:user).tap do |user|
                expect(user.password_set?).to be_truthy
                expect(user.good?).to be_truthy

                user.password = nil
                user.encrypted_password = nil
                expect(user.password_set?).to be_falsey
                expect(user.good?).to be_falsey
            end
        end

        it 'should report correct password reset token status' do
            build(:user).tap do |user|
                user.send_reset_password_instructions
                expect(user.reset_pending?).to be_truthy
                expect(user.reset_expired?).to be_falsey

                Timecop.travel 13.hours.from_now do
                    expect(user.reset_pending?).to be_truthy
                    expect(user.reset_expired?).to be_truthy
                end
            end
        end

        it 'should report lock status' do
            build(:user).tap do |user|
                user.lock_access!
                expect(user.good?).to be_falsey
            end
        end
    end

    describe 'roles' do
        it 'should report no roles' do
            create(:user).tap do |user|
                expect(user.roles.empty?).to be_truthy
            end
        end

        it 'should respond correctly to role functions' do
            create(:user).tap do |user|
                expect(user.is_admin?).to be_falsey
                expect(user.as_admin).to be_nil
            end
        end
    end
end
