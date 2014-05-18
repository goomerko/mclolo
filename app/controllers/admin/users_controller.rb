class Admin::UsersController < Admin::BaseController
  before_action :load_resource, only: [:edit, :update, :destroy]

  def index
    @users = User.all.order(:email)
  end


  def new
    @user = User.new
  end


  def create
    @user = User.new(User.valid_params(params[:user]))
    @user.password = @user.password_confirmation = 'Gtooz4cNrNb8Ps'
    if @user.save
      flash[:notice] = 'Usuario actualizado correctamente'
      redirect_to [:admin, :users]
    else
      flash[:error] = 'No se pudo dar de alta al usuario'
      render 'new'
    end
  end


  def edit
  end


  def update
    if @user.update_attributes(User.valid_params(params[:user]))
      flash[:notice] = 'Usuario actualizado correctamente'
      redirect_to [:admin, :users]
    else
      flash[:error] = 'No se pudo guardar'
      render 'edit'
    end
  end


  def destroy
  end

  private
    def load_resource
      @user = User.find(params[:id])
    end
end
