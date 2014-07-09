class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private
    def authenticate_admin!
      if !current_user.admin?
        flash[:error] = t(:cant_access, scope: [:application])
        redirect_to root_path
      end
    end

    def record_not_found
      render text: "404 Not found", status: 404
    end

    def filter_blank_password
      if params[:user][:password].blank?
        params[:user].delete :password
        params[:user].delete :password_confirmation
      end
    end

end
