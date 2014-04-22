class Admin::SchoolClassesController < ApplicationController
    def index
        @school_classes = SchoolClass.all
    end

    def show
        @school_class = SchoolClass.find(params[:id])
        @tscds = TeacherSchoolClassDiscipline.where(school_class: @school_class)
    end

    def edit
        @school_class = SchoolClass.find(params[:id])
    end

    def update
        @school_class = SchoolClass.find(params[:id])
        if @school_class.update(params.require(:school_class).permit(:name))
            redirect_to admin_school_class_path(@school_class),
                notice: 'Class successfully renamed'
        else
            render action: :edit
        end
    end

    def new
        @school_class = SchoolClass.new
    end

    def create
        @school_class = SchoolClass.new(params.require(:school_class).permit(:name))

        if @school_class.save
            redirect_to admin_school_class_path(@school_class),
                notice: 'Class created successfully'
        else
            render action: :new
        end
    end

    def destroy
        @school_class = SchoolClass.find(params[:id])
        unless @school_class.students.empty?
            redirect_to admin_school_class_path(@school_class),
                alert: %(Can't remove a class while it contains attendees)
            return
        end

        @school_class.destroy
        redirect_to admin_school_classes_path, notice: 'Class successfully removed'
    end

    def add
        redirect = lambda do |msg|
            redirect_to admin_school_class_add_path(@school_class),
                alert: msg
        end

        @school_class = SchoolClass.find(params[:school_class_id])

        if request.post?
            if params[:student].nil?
                redirect.call 'Please select at least one student'
                return
            end

            students = params[:student].map do |id, student|
                if student['id'] == '0'
                    nil
                else
                    id.to_i
                end
            end.delete_if { |e| e.nil? }

            if students.empty?
                redirect.call 'Please select at least one student'
                return
            end

            rogue_students = Student.all.select { |s| students.include?(s.user.id) }
            unless rogue_students.empty?
                redirect.call 'Some of selected students are already attending a class'
                return
            end

            created_students = students.map { |student| Student.create!(user: User.find(student), school_class: @school_class) }

            redirect_to admin_school_class_path(@school_class),
                notice: "Added #{created_students.count} students to #{@school_class.name}"
            return
        end

        ids = Student.all.map { |s| s.user.id } + Teacher.all.map { |t| t.user.id }
        @users = User.all.reject { |u| ids.include?(u.id) }
    end

    def remove
        @school_class = SchoolClass.find(params[:school_class_id])
        @student = Student.find(params[:student_id])

        if @student.school_class == @school_class
            @student.destroy
            redirect_to admin_school_class_path(@school_class), notice: 'Student removed successfully'
        else
            redirect_to admin_school_class_path(@school_class), alert: 'Student is not attending this class'
        end
    end
end