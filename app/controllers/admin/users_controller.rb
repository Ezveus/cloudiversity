class Admin::UsersController < ApplicationController
    def index
        @users = User.order('last_name, first_name')
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        respond_to do |format|
            if @user.update(params.require(:user).permit(:email, :first_name, :last_name))
                format.html do
                    redirect_to admin_user_path(@user),
                        notice: 'User updated successfully.'
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
        @user = User.new(params.require(:user).permit(:login, :email, :first_name, :last_name))

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

    def reset_password
        @user = User.find(params[:user_id])
        if @user.reset_pending? and not @user.reset_expired?
            # Render the view
            return unless params[:confirm]
        end

        @user.send_reset_password_instructions

        redirect_to admin_users_path, notice: "A mail has been sent to #{@user.email} with reset instructions."
    end
end
