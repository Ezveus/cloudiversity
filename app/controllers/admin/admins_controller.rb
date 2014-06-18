class Admin::AdminsController < ApplicationController
    def new
        @admin = Admin.new
        authorize @admin

        if params[:user_id]
            @admin.user = User.find(params[:user_id])
        end
    end

    def create
        user = params.require(:admin).require(:user_id)
        user = User.find user

        @admin = Admin.new(user: user)
        authorize @admin
        if @admin.save
            redirect_to @admin.user, notice: 'User successfully promoted.'
            return
        end

        redirect_to @admin.user, alert: 'Error while promoting user.'
    end

    def destroy
        if params[:user_id]
            @admin = User.find(params[:user_id]).as_admin
            raise ActiveRecord::RecordNotFound if @admin.nil?
        else
            @admin = Admin.find params[:id]
        end
        authorize @admin

        if request.delete?
            user = @admin.user
            @admin.destroy
            redirect_to user, notice: 'User successfully demoted.'
        end
    end
end
