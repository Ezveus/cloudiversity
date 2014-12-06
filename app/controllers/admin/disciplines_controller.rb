class Admin::DisciplinesController < ApplicationController
    def index
        @disciplines = policy_scope(Discipline)
    end

    def show
        @discipline = Discipline.find(params[:id])
        authorize @discipline

        @periods = @discipline.teachings.group_by(&:period).sort_by { |e| e[0].start_date }.reverse
    end

    def new
        @discipline = Discipline.new
        authorize @discipline
    end

    def create
        @discipline = Discipline.new(params.require(:discipline).permit(:name))
        authorize @discipline

        if @discipline.save
            redirect_to admin_discipline_path(@discipline),
                notice: 'Discipline created successfully'
        else
            render action: :new
        end
    end

    def edit
        @discipline = Discipline.find(params[:id])
        authorize @discipline
    end

    def update
        @discipline = Discipline.find(params[:id])
        authorize @discipline
        if @discipline.update(params.require(:discipline).permit(:name))
            redirect_to admin_discipline_path(@discipline),
                notice: 'Discipline successfully renamed'
        else
            render action: :edit
        end
    end

    def destroy
        @discipline = Discipline.find(params[:id])
        authorize @discipline
        @discipline.destroy
    end
end
