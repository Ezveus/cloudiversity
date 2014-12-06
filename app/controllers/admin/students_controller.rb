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
        @student = Student.new()
        @student.user = User.find(params.require(:student).require(:user_id))
        authorize @student

        @student.school_classes = params['student']['school_class_ids'].map { |sc_id| SchoolClass.find(sc_id.to_i) unless sc_id.blank? }.delete_if(&:nil?)
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

    def edit
        @student = Student.find(params[:id])
        authorize @student
    end

    def update
        @student = Student.find(params[:id])
        authorize @student

        @student.school_classes = params['student']['school_class_ids'].map { |sc_id| SchoolClass.find(sc_id.to_i) unless sc_id.blank? }.delete_if(&:nil?)
        if @student.save
            redirect_to @student.user, notice: 'Classes successfully updated'
        else
            render action: :edit
        end
    end
end
