class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  private
    def authenticate_admin!
      if !current_user.admin?
        flash[:error] = t(:cant_access, scope: [:application])
        redirect_to root_path
      end
    end
end
