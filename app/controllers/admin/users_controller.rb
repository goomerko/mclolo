class Admin::UsersController < Admin::BaseController
  before_action :load_resource, only: [:edit, :update, :destroy]

  def index
    @users = User.all

    # search
    @search_term = params[:search_term]
    if @search_term.present?
      @users = @users.where("email LIKE ?", "%#{@search_term}%")
    end

    # paginate and sort
    @users = @users.sorted(params[:sort], "email ASC").paginate(page: params[:page], per_page: 30)
  end


  def new
    @user = User.new
  end


  def create
    @user = User.new(User.valid_params(params))
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
    if @user.update_attributes(User.valid_params(params))
      flash[:notice] = 'Usuario actualizado correctamente'
      redirect_to [:admin, :users]
    else
      flash[:error] = 'No se pudo guardar'
      render 'edit'
    end
  end


  def destroy
    @user.destroy
    redirect_to [:admin, :users]
  end

  private
    def load_resource
      @user = User.find(params[:id])
    end
end
