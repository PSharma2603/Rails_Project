class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
    @provinces = Province.all
    @user.build_address if @user.address.blank?
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to root_path, notice: "Profile updated with address and province."
    else
      Rails.logger.debug "User Errors: #{@user.errors.full_messages}"
      Rails.logger.debug "Address Errors: #{@user.address&.errors&.full_messages}"
      @provinces = Province.all
      render :edit
    end
  end
  
  private

  def user_params
    params.require(:user).permit(
      :province_id,
      address_attributes: [:id, :street_address, :city, :postal_code, :province_id]
    )
  end
end
