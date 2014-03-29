class Admin::SchoolClassesController < ApplicationController
    def index
        @school_classes = SchoolClass.all
    end

    def show
        @school_class = SchoolClass.find(params[:id])
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
        unless @school_class.users.empty?
            redirect_to admin_school_class_path(@school_class),
                alert: %(Can't remove a class while it contains attendees)
            return
        end

        @school_class.delete
        redirect_to admin_school_classes_path, notice: 'Class successfully removed'
    end

    def add
        redirect = lambda do |msg|
            redirect_to admin_school_class_add_path(@school_class),
                alert: msg
        end

        @school_class = SchoolClass.find(params[:school_class_id])

        if request.post?
            if params[:user].nil?
                redirect.call 'Please select at least one user'
                return
            end

            users = params[:user].map do |id, user|
                if user['id'] == '0'
                    nil
                else
                    id.to_i
                end
            end.delete_if { |e| e.nil? }

            if users.empty?
                redirect.call 'Please select at least one user'
                return
            end

            rogue_users = User.where("`id` IN(?) AND `school_class_id` NOT NULL", users);
            unless rogue_users.empty?
                redirect.call 'Some of selected users are already attending a class'
                return
            end

            User.where("`id` IN(?)", users)
                .update_all(school_class_id: @school_class.id)

            redirect_to admin_school_class_path(@school_class),
                notice: "Added #{users.count} users to #{@school_class.name}"
            return
        end

        @users = User.where(school_class_id: nil)
    end

    def remove
        @school_class = SchoolClass.find(params[:school_class_id])
        @user = User.find(params[:user_id])

        if @user.school_class == @school_class
            @user.school_class = nil
            @user.save
            redirect_to admin_school_class_path(@school_class), notice: 'User removed successfully'
        else
            redirect_to admin_school_class_path(@school_class), alert: 'User is not attending this class'
        end
    end
end
