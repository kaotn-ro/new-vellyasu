class WorktimesController < ApplicationController

  def index
    if params[:season].nil?
      @season = Time.now
    else
      year, month = params[:season].split('-').map{|m|
        m.to_i
      }
      @season = Time.mktime(year, month)
    end
    start_day = @season.beginning_of_month
    end_day = @season.end_of_month
    @worktimes = current_user.worktimes.where(start_time: start_day..end_day)
  end

  def create
    time = Time.now
    current_user.worktimes.create(start_time: time,
                    start_breaktime: time.since(2.hour), end_breaktime: time.since(3.hour), work: true)
    redirect_to :root

  end

  def edit
    @worktime = Worktime.find(params[:id])
  end

  def update
    @worktime = Worktime.find(params[:id])
    if @worktime.update_attributes(worktime_params)
      redirect_to :root, success: "お疲れ様でした！"

    else
      redirect_to action: :edit, danger: @worktime.errors.full_messages
    end
  end

  def destroy
    Worktime.find(params[:id]).destroy
    redirect_to action: :index
  end

  private
  def worktime_params
    params.require(:worktime).permit(:start_time, :end_time, :start_breaktime,
                                      :end_breaktime, :active, :work)
  end

end
