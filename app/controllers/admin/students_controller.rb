class Admin::StudentsController < ApplicationController
    def new
        @student = Student.new
        authorize @student

        if params[:user_id]
            @student.user = User.find params[:user_id]
        else
            @student.user = User.new
            authorize @student.user, :create?
        end
    end

    def create
        @student = Student.new(params.require(:student).permit(:school_class_id))
        @student.user = User.find(params.require(:student).require(:user_id))
        authorize @student

        if @student.save
            redirect_to @student.user, notice: 'User successfully promoted'
        else
            redirect_to @student.user, alert: 'Error while promoting the user'
        end
    end

    def destroy
        if params[:user_id]
            @student = User.find(params[:user_id]).as_student
            raise ActiveRecord::RecordNotFound if @student.nil?
        else
            @student = Student.find(params[:id])
        end
        authorize @student

        if request.delete?
            user = @student.user
            @student.destroy
            redirect_to user, notice: 'User successfully demoted'
        end
    end
end
