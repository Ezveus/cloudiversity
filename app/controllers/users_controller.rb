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

    def edit
        @user = User.find params[:id]
        authorize @user
    end

    def new
        @user = User.new
        authorize @user
    end

    def update
        @user = User.find(params[:id])
        authorize @user

        if @user.update(params.require(:user).permit(:email, :first_name, :last_name, :avatar, :phone, :address))
            redirect_to @user,
                        notice: 'User updated successfully.'
        else
            render action: :edit
        end
    end
end
