class Admin::TeachersController < ApplicationController
    def index
        @teachers = policy_scope(Teacher)
    end

    def new
        @teacher = Teacher.new
        authorize @teacher

        if params[:user_id]
            @teacher.user = User.find params[:user_id]
        else
            @teacher.user = User.new
            authorize @teacher.user, :create?
        end
    end

    def create
        user_id = params.require(:teacher).require(:user_id)
        user = User.find(user_id)
        @teacher = Teacher.new(user: user)
        authorize @teacher

        if @teacher.save
            redirect_to @teacher.user, notice: 'User successfully promoted'
            return
        end

        redirect_to @teacher.user, alert: 'Error while promoting user.'
    end

    def destroy
        if params[:user_id]
            @teacher = User.find(params[:user_id]).as_teacher
            raise ActiveRecord::RecordNotFound if @teacher.nil?
        else
            @teacher = Teacher.find params[:id]
        end
        authorize @teacher

        if @teacher.teachings.count > 0
            # We can't allow this
            if request.delete?
                redirect_to @teacher.user, alert: 'Cannot remove if it has assigned classes'
            else
                render 'destroy_error'
            end
        end

        if request.delete?
            user = @teacher.user
            @teacher.destroy
            redirect_to user, notice: 'User successfully demoted'
        end
    end

    # Assignation of a teacher to a set of classes in a given discipline.
    # This method handles both GET and POST methods. In case of POST, it will
    # create all the required join elements (checking all given data in the
    # meantime).
    def assign
        @teacher = Teacher.find params[:teacher_id]
        authorize @teacher

        if request.post?
            if params.require(:teaching)[:classes].nil?
                redirect_to @teacher.user, notice: 'You did not select any classes.'
                return
            end

            classes, discipline = params.require(:teaching).slice(:classes, :discipline).values
            transaction = [] # See comment below

            classes.each do |cls, _|
                # Just check if the ids are valid
                SchoolClass.find cls
                Discipline.find discipline

                # We check if the association already exists, to not double
                # it
                teaching = Teaching.find_or_initialize_by(
                    teacher_id: @teacher.id,
                    school_class_id: cls,
                    discipline_id: discipline)
                next if teaching.persisted?

                transaction << teaching
            end

            # If one fail, all fail: we stock the objects we created to
            # all save at the same time. If any of the data above was invalid,
            # no action will be taken in the final.
            # Note: if one fail to save, it will not block the other. The
            # 'all fail' is valable for validation. If something fails in the
            # loop, it will be silently discarded. But there should be no
            # reason that this would happen.
            transaction.each do |item|
                item.save
            end

            redirect_to @teacher.user, notice: "Added #{transaction.count} class(es) to #{@teacher.full_name}"
        else
            @classes = SchoolClass.all
            @disciplines = Discipline.all

            # We can't assign classes if we don't have at least a class, a period and a discipline.
            if @classes.count == 0
                redirect_to @teacher.user, alert: 'There are no defined classes. Please add a class first.'
            elsif @disciplines.count == 0
                redirect_to @teacher.user, alert: 'There are no defined disciplines. Please add a discipline first.'
            end
        end
    end

    # Change a teacher assigned to a class
    def transfer
        @teacher = Teacher.find params[:teacher_id]
        @discipline = Discipline.find params[:discipline]
        @school_class = SchoolClass.find params[:school_class]

        @teaching = Teaching.find_by!(
            teacher: @teacher,
            discipline: @discipline,
            school_class: @school_class)

        authorize @teaching, :update?

        if request.post?
            new_teacher = Teacher.find params.require(:teaching).require(:teacher_id)
            @teaching.teacher = new_teacher
            @teaching.save

            redirect_to @teacher.user, notice: "The discipline #{@discipline.name} in #{@school_class.name} has been transferred to #{new_teacher.full_name}."
        end
    end

    # Delete an assignation
    def unassign
        @teacher = Teacher.find params[:teacher_id]
        @discipline = Discipline.find params[:discipline]
        @school_class = SchoolClass.find params[:school_class]

        @teaching = Teaching.find_by!(
            teacher: @teacher,
            discipline: @discipline,
            school_class: @school_class)

        authorize @teaching, :delete?

        if request.delete?
            @teaching.destroy
            redirect_to @teacher.user, notice: "The class has been unassigned. All associated data has been deleted."
        end
    end

    def list_teachings
        authorize(Teacher)
        @teacher = User.find(params[:id])
        respond_to do |format|
            format.json do

                if @teacher.is_teacher?
                    @teacher = @teacher.as_teacher
                else
                    return render(json: { error: "Invalid role" }, status: :bad_request)
                end

                @teachings = @teacher.teachings.group_by(&:discipline).map { |discipline, teachings| {
                        discipline: { id: discipline.id, name: discipline.name },
                        school_classes: teachings.map { |teaching| {
                                school_class_id: teaching.school_class.id, school_class_name: teaching.school_class.name,
                                period_id: teaching.school_class.period.id, period_name: teaching.school_class.period.name
                        }}
                }}

                render json: @teachings
            end
        end
    end
end
