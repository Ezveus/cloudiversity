require 'spec_helper'

describe Admin::UsersController do
    describe "Show tests" do
        before :each do
            @user = FactoryGirl.create :user
            get :show, id: @user
        end

        it "should find the created user" do
            response.should be_success
        end
    end

    describe "Create an user" do
    end
end
