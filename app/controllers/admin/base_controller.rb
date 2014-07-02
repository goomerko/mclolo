class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  private
  def authenticate_admin!
    if !current_user.admin?
      flash[:error] = "No puedes acceder aquí"
      redirect_to root_path
    end
  end

  def authenticate_manager!
    unless current_user.admin? || current_user.manager?
      flash[:error] = "No puedes acceder aquí"
      redirect_to root_path
    end
  end
end
