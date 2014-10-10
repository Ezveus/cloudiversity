require 'spec_helper'

include SpecControllerHelpers

test_discipline = FactoryGirl.create(:discipline)

describe Admin::DisciplinesController do
    before(:each) do
        @admin = FactoryGirl.create(:admin)
    end

    describe "GET 'index'" do
        success_and_authorization_tests(self, action: :index, verb: :get)

        it "should list all disciplines if logged" do
            disciplines = []
            3.times { |n| disciplines << FactoryGirl.create(:multiple_disciplines) }
            sign_in @admin
            get :index
            response.should_not redirect_to(new_user_session_path)
            expect(assigns(:disciplines)).to eq(disciplines)
        end
    end

    describe "GET 'show'" do
        before(:each) do
            @discipline = FactoryGirl.create(:discipline)
        end

        success_and_authorization_tests(self, action: :show, verb: :get, params: { id: test_discipline })
    end

    describe "GET 'new'" do
        success_and_authorization_tests(self, action: :new, verb: :get)
    end

    describe "POST 'create'" do
        before(:each) do
            @discipline = FactoryGirl.attributes_for :discipline
        end

        success_and_authorization_tests(self, action: :create, verb: :post, params: { id: FactoryGirl.attributes_for(:discipline) })

        it "should create the discipline" do
            sign_in @admin
            post :create, discipline: @discipline
            response.should redirect_to(admin_discipline_path(assigns(:discipline)))
            expect(assigns(:discipline).id).not_to eq(nil)
        end
    end

    describe "GET 'edit'" do
        success_and_authorization_tests(self, action: :edit, verb: :get, params: { id: test_discipline })
    end

    describe "PUT 'update'" do
        before(:each) do
            @discipline = FactoryGirl.create(:discipline)
        end

        success_and_authorization_tests(self, action: :update, verb: :put, params: { id: test_discipline })

        it "should update discipline" do
            sign_in @admin
            discipline_params = FactoryGirl.attributes_for(:multiple_disciplines)
            put :update, id: @discipline, discipline: discipline_params
            response.should redirect_to(admin_discipline_path(assigns(:discipline)))
        end
    end

    describe "DELETE 'destroy'" do
        before(:each) do
            @discipline = FactoryGirl.create(:discipline)
        end

        success_and_authorization_tests(self, action: :destroy, verb: :delete, params: { id: test_discipline })

        it "should delete the discipline and the associated user" do
            sign_in @admin
            expectation = expect { delete :destroy, id: @discipline }
            expectation.to change(discipline, :count).by(-1)
            response.should redirect_to(admin_disciplines_path)
        end
    end
end
