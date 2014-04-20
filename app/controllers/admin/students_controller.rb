class Admin::StudentsController < ApplicationController
    def index
        @students = Student.all
    end

    def show
        @student = Student.find(params[:id])
        @tscds = TeacherSchoolClassDiscipline.where(school_class: @student.school_class)
    end

    def new
        @student = Student.new
    end

    def create
        user_id = params.require(:student).require(:user)
        user = User.find(user_id)
        school_class_id = params.require(:student).require(:school_class)
        school_class = SchoolClass.find(school_class_id)
        @student = Student.new(user: user, school_class: school_class)

        if @student.save
            redirect_to admin_student_path(@student), notice: 'Student created successfully'
        else
            render action: :new
        end
    end

    def edit
        @student = Student.find(params[:id])
    end

    def update
        user_id = params.require(:student).require(:user)
        user = User.find(user_id)
        school_class_id = params.require(:student).require(:school_class)
        school_class = SchoolClass.find(school_class_id)
        @student = Student.find(params[:id])

        @student.user = user if user != @student.user
        @student.school_class = school_class if school_class != @student.school_class
        if @student.save
            redirect_to admin_student_path(@student), notice: 'Student updated successfully'
        else
            render action: :edit
        end
    end

    def destroy
        @student = Student.find(params[:id])
        @student.destroy

        redirect_to admin_students_path, notice: "Student #{@student.user.login} has been deleted."
    end
end
