require 'spec_helper'

describe StaticController, type: :controller do
    describe 'As admin' do
        before(:each) do
            sign_in create(:admin).user
        end

        it 'GET home' do
            get :home
            expect(response).to be_success
        end

        it 'GET admin' do
            get :admin
            expect(response).to be_success
        end
    end

    describe 'As user' do
        before(:each) do
            sign_in create(:user)
        end

        it 'GET home' do
            get :home
            expect(response).to be_success
        end

        it 'GET admin' do
            get :admin
            expect(response).to redirect_to(root_path)
        end

        it 'GET version' do
            get :version, format: :json
            expect(response).to be_success

            json = JSON.parse(response.body)
            expect(json['version']).to eq('test')
            expect(json['modules']).to eq([])
        end
    end

    describe 'Not logged in' do
        it 'GET home' do
            get :home
            expect(response).to redirect_to(new_user_session_path)
        end

        it 'GET admin' do
            get :admin
            expect(response).to redirect_to(new_user_session_path)
        end

        it 'GET version' do
            get :version, format: :json
            expect(response).to be_success

            json = JSON.parse(response.body)
            expect(json['version']).to eq('test')
        end
    end
end