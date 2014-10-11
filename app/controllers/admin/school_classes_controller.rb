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
        @periods = @school_class.teacher_school_class_discipline.group_by { |tscd| tscd.period }
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

    # The wizard
    def add
        authorize(@school_class = SchoolClass.find(params[:school_class_id]))
        @school_classes = policy_scope(SchoolClass).where.not(id: @school_class.id)
    end

    # Adding new students from list of non-assigned
    def add_new
        authorize(@school_class = SchoolClass.find(params[:school_class_id]))
        @users = User.joins("LEFT JOIN abstract_roles ON users.id = abstract_roles.user_id").group("users.id").having("COUNT(abstract_roles.id) = 0")
    end

    # Transfer from an existing class
    def transfer
        authorize(@school_class = SchoolClass.find(params[:school_class_id]))
        @old_school_class = SchoolClass.find(params[:old_school_class_id])

        redirect_to [ :admin, @school_class ], notice: 'Can\'t move students in the same class' if @school_class == @old_school_class
    end

    # Proceeding to add
    def add_proceed
        # Get the mode (add/transfer)
        raise "Invalid mode" if not %w{add transfer}.include? params.require(:mode)
        newcomers = params.require(:newcomers).map { |e| e.to_i }

        authorize(@school_class = SchoolClass.find(params[:school_class_id]))
        @old_school_class = SchoolClass.find(params[:old_school_class_id]) if params[:mode] == 'transfer'

        if @school_class == @old_school_class
            redirect_to [ :admin, @school_class ], alert: 'Source and destination classes are the same'
            return
        end

        newcomers.each do |nc|
            if params[:mode] == 'add'
                u = User.find_by(id: nc)
                next if u.nil? || u.roles.count > 0

                student = Student.new(user: u)
            else
                student = Student.find_by(id: nc)
                next if student.nil? || student.school_class != @old_school_class
            end

            student.school_class = @school_class
            student.save!
        end

        redirect_to [ :admin, @school_class ], notice: 'Students have been added'
    end
end
