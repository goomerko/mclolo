class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    return if current_user.admin?

    flash[:error] = "No puedes acceder aquí"
    redirect_to root_path
  end

  def authenticate_manager!
    return if current_user.admin? || current_user.manager?

    flash[:error] = "No puedes acceder aquí"
    redirect_to root_path
  end
end
