require 'spec_helper'

describe Teacher do
    before(:each) do
        @teacher_attributes = FactoryGirl.attributes_for(:teacher)
    end

    it "should create a new instance of Teacher with valids attributes" do
        FactoryGirl.create(:teacher).should be_valid
    end

    it "should fail to create a teacher with a nil user" do
        Teacher.create(@teacher_attributes.merge(user: nil)).should_not be_valid
    end

    it "should fail to create a teacher with an unstored user" do
        Teacher.create(@teacher_attributes.merge(user: FactoryGirl.build(:user))).should_not be_valid
    end
end
