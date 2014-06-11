class Admin::TeachersController < ApplicationController
    def index
        @teachers = Teacher.all
    end

    def show
        @teacher = Teacher.find(params[:id])
        @tscds = TeacherSchoolClassDiscipline.where(teacher: @teacher)
    end

    def new
        @teacher = Teacher.new
    end

    def create
        user_id = params.require(:teacher).require(:user)
        user = User.find(user_id)
        @teacher = Teacher.new(user: user)

        if @teacher.save
            redirect_to admin_teacher_path(@teacher), notice: 'Teacher created successfully'
        else
            render action: :new
        end
    end

    def edit
        @teacher = Teacher.find(params[:id])
    end

    def update
        @teacher = Teacher.find(params[:id])
        user_id = params.require(:teacher).require(:user)
        user = User.find(user_id)

        @teacher.user = user if user != @teacher.user
        if @teacher.save
            redirect_to admin_teacher_path(@teacher), notice: 'Teacher updated successfully. '
        else
            render action: :edit
        end
    end

    def destroy
        @teacher = Teacher.find(params[:id])
        user = @teacher.user
        @teacher.destroy

        redirect_to admin_teachers_path, notice: "Teacher #{user.login} has been deleted."
    end

    def add_school_class
        @teacher = Teacher.find(params[:teacher_id])

        if request.post?
            filtered_params = params.require(:teacher).permit(:school_classes, disciplines: [])

            school_class = SchoolClass.find(filtered_params["school_classes"])
            filtered_params["disciplines"].each do |discipline_id|
                unless discipline_id.blank?
                    discipline = Discipline.find(discipline_id)
                    TeacherSchoolClassDiscipline.create!(teacher: @teacher, school_class: school_class, discipline: discipline)
                end
            end

            redirect_to admin_teacher_path(@teacher), notice: 'Teacher updated successfully. '
        end
    end

    def rem_school_class
        @teacher = Teacher.find(params[:teacher_id])
        @tscds = TeacherSchoolClassDiscipline.where(teacher: @teacher)

        if request.post?
            filtered_params = params.require(:teacher).permit(disciplines: [])

            filtered_params["disciplines"].each do |tscd_id|
                TeacherSchoolClassDiscipline.delete(tscd_id) unless tscd_id.blank?
            end

            redirect_to admin_teacher_path(@teacher), notice: 'Teacher updated successfully. '
        end
    end
end
