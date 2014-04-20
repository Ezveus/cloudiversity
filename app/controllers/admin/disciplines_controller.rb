class Admin::DisciplinesController < ApplicationController
    def index
        @disciplines = Discipline.all
    end

    def show
        @discipline = Discipline.find(params[:id])
        @tscds = TeacherSchoolClassDiscipline.where(discipline: @discipline)
    end

    def new
        @discipline = Discipline.new
    end

    def create
        @discipline = Discipline.new(params.require(:discipline).permit(:name))

        if @discipline.save
            redirect_to admin_discipline_path(@discipline),
                notice: 'Discipline created successfully'
        else
            render action: :new
        end
    end

    def edit
        @discipline = Discipline.find(params[:id])
    end

    def update
        @discipline = Discipline.find(params[:id])
        if @discipline.update(params.require(:discipline).permit(:name))
            redirect_to admin_discipline_path(@discipline),
                notice: 'Discipline successfully renamed'
        else
            render action: :edit
        end
    end

    def destroy
        @discipline = Discipline.find(params[:id])
        @discipline.destroy
    end
end
