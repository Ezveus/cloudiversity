class Admin::UsersController < ApplicationController
    def index
        @users = policy_scope(User).paginate(page: params[:page])
    end

    def edit
        @user = User.find(params[:id])
        authorize @user
    end

    def update
        @user = User.find(params[:id])
        authorize @user

        respond_to do |format|
            if @user.update(params.require(:user).permit(:email, :first_name, :last_name, :avatar))
                format.html do
                    redirect_to @user,
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
        authorize @user
    end

    def new
        @user = User.new
        authorize @user
    end

    def create
        @user = User.new(params.require(:user).permit(:login, :email, :first_name, :last_name, :avatar))
        authorize @user

        respond_to do |format|
            if @user.save
                format.html do
                    redirect_to @user, notice: 'User created successfully'
                end
            else
                format.html do
                    render action: :new
                end
            end
        end
    end

    def destroy
        @user = User.find(params[:user_id] || params[:id])
        authorize @user

        if request.delete?
            if @user.roles.count > 0
                redirect_to @user, alert: 'This user has still roles assigned. Please demote him from all his roles before deleting it.'
                return
            end

            @user.destroy
            redirect_to admin_users_path, notice: "User #{@user.login} has been deleted."
        end
    end

    def reset_password
        @user = User.find(params[:user_id])
        authorize @user

        if @user.reset_pending? and not @user.reset_expired?
            # Render the view
            return unless params[:confirm]
        end

        @user.send_reset_password_instructions

        redirect_to admin_users_path, notice: "A mail has been sent to #{@user.email} with reset instructions."
    end

    def unlock
        @user = User.find(params[:user_id])
        authorize @user

        if @user.locked_at?
            @user.unlock_access!
            redirect_to @user, notice: 'Account unlocked'
        else
            redirect_to @user, alert: 'User was not locked'
        end
    end

    def search
        authorize User.new

        if request.post?

            respond_to do |f|
                f.json {
                    login = params.require(:login)
                    render json: (User.where(['`login` LIKE ?', login + '%']).limit(5).map do |u|
                        { value: u.login, title: u.full_name, url: user_path(u), text: u.login }
                    end)
                }
                f.html {
                    if (@user = User.find_by(login: params.require(:login)))
                        redirect_to @user
                        return
                    end
                }
            end
        end
    end
end
