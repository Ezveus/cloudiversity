class Admin::PeriodsController < ApplicationController
    def index
        @periods = policy_scope(Period).sort_by(&:start_date).group_by(&:relative).slice(:past, :current, :future)
        @periods_map = {
            past: 'Past',
            current: 'Current',
            future: 'Future'
        }
    end

    def show
        @period = Period.find(params[:id])
        authorize(@period)
    end

    def new
        @period = Period.new
        authorize(@period)
    end

    def create
        @period = Period.new(params.require(:period).permit(:name, :start_date, :end_date))
        authorize(@period)

        if @period.save
            redirect_to admin_period_path(@period),
                notice: 'Period successfully created'
        else
            render action: :new
        end
    end

    def edit
        @period = Period.find(params[:id])
        authorize(@period)
    end

    def update
        @period = Period.find(params[:id])
        authorize(@period)

        if @period.update(params.require(:period).permit(:name, :start_date, :end_date))
            redirect_to admin_period_path(@period),
                notice: 'Period successfully updated'
        else
            render action: :edit
        end
    end

    def destroy
        @period = Period.find(params[:id])
        authorize(@period)

        @period.destroy
        redirect_to admin_periods_path, notice: 'Period successfully removed'
    end

    def destroy_confirmation
        @period = Period.find(params[:id])
        authorize(@period)
    end
end
