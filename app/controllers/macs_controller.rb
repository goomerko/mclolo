class MacsController < ApplicationController
  before_action :load_resource, only: [:edit, :update, :destroy]

  def index
    @macs = current_user.available_macs

    # search
    @search_term = params[:search_term] || session[:search_term]
    session[:search_term] = @search_term

    if @search_term.present?
      @macs = @macs.includes(:user).where("macs.comment LIKE ? OR macs.mac LIKE ? or users.email LIKE ?",
       "%#{@search_term}%", "%#{@search_term}%", "%#{@search_term}%").references(:user)
    end

    # paginate and sort
    @macs = @macs.includes(:user).sorted(params[:sort]).paginate(page: params[:page], per_page: 20).references(:user)
  end

  def new
    @mac = Mac.new
  end


  def create
    @mac = Mac.new(Mac.valid_params(params[:mac]))
    @mac.user = current_user
    if @mac.save
      redirect_to [:macs]
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @mac.update_attributes(Mac.valid_params(params[:mac]))
      redirect_to :macs
    else
      render 'edit'
    end
  end

  def destroy
    @mac.destroy
    redirect_to [:macs]
  end

  private
    def load_resource
      @mac = current_user.available_macs.find(params[:id])
    end
end
