class UsersController < ApplicationController
    def show
        @user = User.find params[:id]
        authorize @user

        respond_to do |format|
            format.json { render json: current_user.to_json }
            format.html
        end
    end

    def current
        authorize current_user, :show?
        respond_to do |format|
            format.json { render json: current_user.to_json }
            format.html { redirect_to current_user }
        end
    end
end
