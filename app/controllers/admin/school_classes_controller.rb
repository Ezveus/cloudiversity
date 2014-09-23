class Admin::SchoolClassesController < ApplicationController
    def index
        multirole do |role|
            role.json_for :admin

            role.admin do
                @school_classes = SchoolClass.all

                role.json { @school_classes }
            end

            role.teacher do |teacher|
                @school_classes = teacher.teacher_school_class_discipline.group_by { |tscd| tscd.discipline }
            end
        end
    end

    def show
        @school_class = SchoolClass.find(params[:id])
        authorize @school_class
    end

    def edit
        @school_class = SchoolClass.find(params[:id])
        authorize @school_class
    end

    def update
        @school_class = SchoolClass.find(params[:id])
        authorize @school_class
        if @school_class.update(params.require(:school_class).permit(:name))
            redirect_to admin_school_class_path(@school_class),
                notice: 'Class successfully renamed'
        else
            render action: :edit
        end
    end

    def new
        @school_class = SchoolClass.new
        authorize @school_class
    end

    def create
        @school_class = SchoolClass.new(params.require(:school_class).permit(:name))
        authorize @school_class

        if @school_class.save
            redirect_to admin_school_class_path(@school_class),
                notice: 'Class created successfully'
        else
            render action: :new
        end
    end

    def destroy
        @school_class = SchoolClass.find(params[:id])
        authorize @school_class

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
        authorize @school_class, :update?

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

        @users = User.all.select { |u| u.roles.empty? }
    end

    def remove
        @school_class = SchoolClass.find(params[:school_class_id])
        authorize @school_class, :update?

        @student = Student.find(params[:student_id])

        if @student.school_class == @school_class
            @student.destroy
            redirect_to admin_school_class_path(@school_class), notice: 'Student removed successfully'
        else
            redirect_to admin_school_class_path(@school_class), alert: 'Student is not attending this class'
        end
    end
end
