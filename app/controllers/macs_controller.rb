class MacsController < ApplicationController
  before_action :load_resource, only: [:edit, :update, :destroy]

  def index
    if current_user.admin?
      @macs = Mac.all
    else
      @macs = current_user.macs
    end

    # search
    @search_term = params[:search_term]
    if @search_term.present?
      @search_term = @search_term.upcase
      @macs = @macs.includes(:user).where("macs.comment LIKE ? OR macs.mac LIKE ? or users.email LIKE ?",
       "%#{@search_term}%", "%#{@search_term}%", "%#{@search_term}%").references(:user)
    end

    # Paginate
    @macs = @macs.paginate(page: params[:page], per_page: 30)
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
      if current_user.admin?
        @mac = Mac.find(params[:id])
      else
        @mac = current_user.macs.find(params[:id])
      end
    end
end
