class Admin::UsersController < Admin::BaseController
  skip_before_action :authenticate_admin!
  before_action :authenticate_manager!
  before_action :load_resource, only: [:edit, :update, :destroy]
  before_action :load_nodes, only: [:new, :create, :edit, :update]
  before_action :filter_blank_password, only: [:create, :update]

  def index
    if current_user.admin?
      @users = User.all
    else
      @users = current_user.children
    end

    # nodes filter
    if params[:node_id]
      @users = @users.includes(:nodes).where("nodes_users.node_id = ?", params[:node_id]).references(:nodes)
      @node = Node.find(params[:node_id])
    end

    # search
    @search_term = params[:search_term]
    if @search_term.present?
      @users = @users.where("email LIKE ?", "%#{@search_term}%")
    end

    # paginate and sort
    @users = @users.sorted(params[:sort], "email ASC").paginate(page: params[:page], per_page: 20)
  end


  def new
    @user = User.new
  end


  def create
    @user = User.new(User.valid_params(params, current_user))

    if @user.password.blank?
      @user.password = @user.password_confirmation = 'Gtooz4cNrNb8Ps'
    end

    @user.parent = current_user
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
    if @user.update_attributes(User.valid_params(params, current_user))
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

    def load_nodes
      if current_user.admin?
        @available_nodes = Node.all.order(:name)
      else
        @available_nodes = current_user.nodes.order(:name)
      end
    end
end
