class Admin::UsersController < ApplicationController
    def index
        @users = User.all
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        respond_to do |format|
            if @user.update(params.require(:user).permit(:email))
                format.html do
                    redirect_to admin_user_path(@user),
                        notice: 'User updated successfully. ' +
                            'E-mail changes will be applied upon confirmation ' +
                            'by the user.'
                end
            else
                format.html do
                    render action: :edit
                end
            end
        end
    end

    def show
        @user = User.find(params[:id])
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(params.require(:user).permit(:login, :email))
        @user.password = generate_password

        respond_to do |format|
            if @user.save
                format.html do
                    redirect_to admin_user_path(@user), notice: 'User created successfully'
                end
            else
                format.html do
                    render action: :new
                end
            end
        end
    end

    def destroy
        @user = User.find(params[:id])
        @user.delete

        redirect_to admin_users_path, notice: "User #{@user.login} has been deleted."
    end

    private

    def generate_password
        "password"
    end
end
