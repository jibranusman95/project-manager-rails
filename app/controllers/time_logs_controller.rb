# frozen_string_literal: true

class TimeLogsController < ApplicationController
  before_action :set_time_log, only: %i[show edit update destroy]

  # GET /time_logs
  # GET /time_logs.json
  def index
    @time_logs = TimeLog.all
  end

  # GET /time_logs/1
  # GET /time_logs/1.json
  def show; end

  # GET /time_logs/new
  def new
    @time_log = TimeLog.new
  end

  # GET /time_logs/1/edit
  def edit; end

  # POST /time_logs
  # POST /time_logs.json
  def create
    request.params[:time_log][:user_id] = current_user.id
    @time_log = TimeLog.new(time_log_params)
    if @time_log.save
      redirect_to @time_log, notice: 'Time log was successfully created'
    else
      render :new
    end
  end

  # PATCH/PUT /time_logs/1
  # PATCH/PUT /time_logs/1.json
  def update
    request.params[:time_log][:user_id] = current_user.id
    respond_to do |format|
      if @time_log.update(time_log_params)
        format.html { redirect_to @time_log, notice: 'Time log was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_log }
      else
        format.html { render :edit }
        format.json { render json: @time_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_logs/1
  # DELETE /time_logs/1.json
  def destroy
    @time_log.destroy
    respond_to do |format|
      format.html { redirect_to time_logs_url, notice: 'Time log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_time_log
    @time_log = TimeLog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def time_log_params
    params.require(:time_log).permit(:project_id, :user_id, :hours)
  end
end