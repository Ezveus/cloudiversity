require 'spec_helper'

include SpecControllerHelpers

test_teacher = FactoryGirl.create(:teacher)

describe Admin::TeachersController do
    before(:each) do
        @admin = FactoryGirl.create(:admin)
    end

    describe "GET 'index'" do
        success_and_authorization_tests(self, action: :index, verb: :get)

        it "should list all teachers if logged" do
            teachers = []
            3.times { |n| teachers << FactoryGirl.create(:multiple_teachers) }
            sign_in @admin
            get :index
            response.should_not redirect_to(new_user_session_path)
            expect(assigns(:teachers)).to eq(teachers)
        end
    end

    describe "GET 'show'" do
        before(:each) do
            @teacher = FactoryGirl.create(:teacher)
        end

        success_and_authorization_tests(self, action: :show, verb: :get, params: { id: test_teacher })
    end

    describe "GET 'new'" do
        success_and_authorization_tests(self, action: :new, verb: :get)
    end

    describe "POST 'create'" do
        before(:each) do
            @teacher = FactoryGirl.attributes_for :teacher
        end

        success_and_authorization_tests(self, action: :create, verb: :post, params: { teacher: { user: test_teacher.user.id } })

        it "should create the teacher" do
            sign_in @admin
            post :create, teacher: @teacher
            response.should redirect_to(admin_teacher_path(assigns(:teacher)))
            expect(assigns(:teacher).id).not_to eq(nil)
        end
    end

    describe "GET 'edit'" do
        success_and_authorization_tests(self, action: :edit, verb: :get, params: { id: test_teacher })
    end

    describe "PUT 'update'" do
        before(:each) do
            @teacher = FactoryGirl.create(:teacher)
            # @school_class = FactoryGirl.create(:school_class)
            # @discipline = FactoryGirl.create(:discipline)
        end

        success_and_authorization_tests(self, action: :update, verb: :put, params: { id: test_teacher })

        it "should update school_classes and disciplines of the teacher" do
            sign_in @admin
            teacher_params = FactoryGirl.attributes_for(:multiple_teachers)
            put :update, id: @teacher, teacher: teacher_params
            response.should redirect_to(admin_teacher_path(assigns(:teacher)))
        end
    end

    describe "DELETE 'destroy'" do
        before(:each) do
            @teacher = FactoryGirl.create(:teacher)
        end

        success_and_authorization_tests(self, action: :destroy, verb: :delete, params: { id: test_teacher })

        it "should delete the teacher" do
            sign_in @admin
            expectation = expect { delete :destroy, id: @teacher }
            expectation.to change(Teacher, :count).by(-1)
            response.should redirect_to(admin_teachers_path)
        end
    end
end
