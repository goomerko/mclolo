class Admin::NodesController < Admin::BaseController
  before_action :load_resource, only: [:edit, :update, :destroy]

  def index
    @nodes = Node.all.order(:name)
  end

  def new
    @node = Node.new
  end

  def create
    @node = Node.new(Node.valid_params(params))
    if @node.save
      flash[:notice] = "Nodo actualizado correctamente"
      redirect_to [:admin, :nodes]
    else
      flash[:error] = "No se pudo dar de alta el nodo"
      render "new"
    end
  end

  def edit
  end

  def update
    if @node.update_attributes(Node.valid_params(params))
      flash[:notice] = "Nodo actualizado correctamente"
      redirect_to [:admin, :nodes]
    else
      flash[:error] = "No se pudo guardar"
      render "edit"
    end
  end

  def destroy
    @node.destroy
    redirect_to [:admin, :nodes]
  end

  private

  def load_resource
    @node = Node.find(params[:id])
  end
end
