# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :shorten_params, only: %i[update update_password]
  before_action :set_user, only: %i[show edit update destroy update_password]

  def show
    @top_projects = Project.highest_earning
    @bottom_projects = Project.lowest_earning

    @time_log_sorted_projects = Project.sort_by_time_logged_this_month
    @payment_sorted_projects = Project.sort_by_payment_this_month
  end

  def edit; end

  def change_password; end

  def update_password
    if current_user.valid_password?(@user_params[:password])
      validate_and_confirm_password_update
    else
      @user.errors.add(:password, 'Current password does not match')
      render :change_password
    end
  end

  def update
    if @user.update(user_params)
      redirect_to home_path, notice: 'User successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to home_path, notice: 'Sorry to see you go!'
  end

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def shorten_params
    @user_params = params[:user]
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :image, :enabled)
  end

  def confirm_password_update
    if @user_params[:new_password] == @user_params[:confirm_password]
      @user.update(password: @user_params[:new_password])
      sign_in(@user, bypass: true)
      redirect_to home_path, notice: 'Password successfully changed'
    else
      @user.errors.add(:new_password, 'Password confirmations do not match')
      render :change_password
    end
  end

  def validate_and_confirm_password_update
    if @user_params[:new_password].present?
      confirm_password_update
    else
      @user.errors.add(:new_password, 'Please enter a new password to update')
      render :change_password
    end
  end
end
