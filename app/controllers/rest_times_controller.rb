class RestTimesController < ApplicationController
  def create
    RestTime.create(worktime_id: params[:worktime_id], start_time: Time.now)
    redirect_to :root
  end

  def update
    @rest_time = RestTime.find(params[:id])
    @rest_time.update_attributes(resttime_params)
    @rest_time.errors.messages
    redirect_to :root
  end

  private
  def resttime_params
    params.require(:rest_times).permit(:end_time)
  end
end